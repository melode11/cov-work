//
//  CallHistoryDAO.m
//  AuroraPhone
//
//  Created by Yao Melo on 11/14/12.
//
//

#import "CallHistoryDAO.h"
#import "Utilities/DTConstants.h"
#import "Utilities/NSString+Name_Device.h"
#import "Utilities/constants.h"

#define kCallHistoryFile @"callhistory"
#define kUnViewedMissCount @"unViewedMissCount"

@implementation CallHistoryDAO
@synthesize unViewedMissCount = _unViewedMissCount;
@synthesize localMissCallCount = _localMissCallCount;

-(id)initWithPath:(NSString *)path
{
    self = [super init];
    if(self)
    {
        _db = [[SqliteDatabaseWrapper alloc] initWithPath:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",kCallHistoryFile]]];
        [_db open];
        NSArray *columnDescriptors = [NSArray arrayWithObjects:[SqliteColumnDescriptor descriptorWithColumnName:kHistoryRecordType andType:eColumnTypeInteger],
         [SqliteColumnDescriptor descriptorWithColumnName:kHistoryRecordPeerId andType:eColumnTypeText],
         [SqliteColumnDescriptor descriptorWithColumnName:kHistoryRecordPeerDisplayName andType:eColumnTypeText],
         [SqliteColumnDescriptor descriptorWithColumnName:kHistoryRecordPeerDeviceType andType:eColumnTypeText],
         [SqliteColumnDescriptor descriptorWithColumnName:kHistoryRecordTime andType:eColumnTypeFoat],
         [SqliteColumnDescriptor descriptorWithColumnName:kHistoryRecordCallId andType:eColumnTypeInteger],
        nil];
        [_db createNotExistTableWithName:@"history_record" primaryKey:kHistoryRecordId columnDescriptors:columnDescriptors];
        BOOL isExist = [_db checkColumnExists:kHistoryRecordCallId from:@"history_record"];

        if (!isExist) {
            [_db executeSql:[NSString stringWithFormat:@"alter table history_record add column %@ integer default -1", kHistoryRecordCallId] withParameterArray:nil];
        }
        [_db close];
        [self load];
    }
    return self;
}

- (void)dealloc
{
    [_db release];
    [super dealloc];
}

-(NSArray *)allRecords
{
    [_db open];
    NSArray* records = [_db querySql:@"select * from history_record order by time desc" withParameters: nil];
    [_db close];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[records count]];
    for(NSDictionary* dic in records)
    {
        HistoryRecord *rec = [HistoryRecordBuilder buildFromDict:dic];
        if(rec)
        {
            [result addObject:rec];
        }
    }
    return result;
    
}

-(NSArray *)filteredRecords:(BOOL (^)(HistoryRecord *))filterBlock
{
    [_db open];
    NSArray* records = [_db querySql:@"select * from history_record order by time desc" withParameters: nil];
    [_db close];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[records count]];
    for(NSDictionary* dic in records)
    {
        HistoryRecord *record = [HistoryRecordBuilder buildFromDict:dic];
        
        if(record!=nil && (filterBlock == nil || filterBlock(record)))
        {
            [result addObject:record];
        }
    }
    return result;
    
}

-(void)removeHistoryRecords:(NSArray*) records
{
    @try {
        [_db open];
        //use transaction to speed up batch execution.
        [_db beginTransaction];
        for(HistoryRecord *record in records)
        {
            if(record.recordId >= 0)
            {
                [_db executeSql:[NSString stringWithFormat: @"delete from history_record where %@ = ?",kHistoryRecordId] withParameters:[NSNumber numberWithInt:record.recordId], nil];
            }
        }
        [_db commitTransaction];
    }
    @catch (NSException *exception) {
        [_db rollbackTransaction];
    }
    @finally {
        [_db close];
    }
}

// Need db store
-(void)resetMissCount {
    _unViewedMissCount = 0;
    _missCountDirty = YES;
}

-(void)addHistoryRecord:(HistoryRecord *)record
{
    [_db open];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[HistoryRecordBuilder toDictionary:record]];
    [dic removeObjectForKey:kHistoryRecordId];
    [_db insertRow:dic toTable:@"history_record"];
    [_db close];
}

-(NSInteger)unViewedMissCount
{
    return _unViewedMissCount;
}

-(void)setUnViewedMissCount:(NSInteger)unViewedMissCount
{
    _unViewedMissCount = unViewedMissCount;
    _missCountDirty = YES;
}

-(void)store
{
    //do nothing
    if(_missCountDirty)
    {
        _missCountDirty = NO;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_unViewedMissCount] forKey:kUnViewedMissCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)clean
{
    [_db open];
    [_db executeSql:@"delete from history_record" withParameters: nil];
    [_db close];
    _unViewedMissCount = 0;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUnViewedMissCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _missCountDirty = NO;
}

-(void)load
{
    _unViewedMissCount = [[[NSUserDefaults standardUserDefaults] objectForKey:kUnViewedMissCount] integerValue];
    _missCountDirty = NO;
}

-(void)removeLocalMissedCall {
    NSArray *allRecord = [self allRecords];
    NSMutableArray *missed = [[NSMutableArray alloc] init];
    for(HistoryRecord* record in allRecord)
    {
        if(record.type == eHistoryRecordIncomingMiss
           && record.callId == 0)
        {
            [missed addObject:record];
        }
    }
    _localMissCallCount = [missed count];
    [self removeHistoryRecords:missed];
    [missed release];
    [self store];
}

-(void)updateMissedCallRecords:(NSArray*)records {
    // remove local missedcall datum
    [self removeLocalMissedCall];

    int serverMissCount = 0;
    @try {
        [_db open];
        //use transaction to speed up batch execution.
        [_db beginTransaction];
        for(HistoryRecord *record in records)
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[HistoryRecordBuilder toDictionary:record]];
            // Query exist
            NSString* sql = [NSString stringWithFormat:@"select id from history_record where %@=%d", kHistoryRecordCallId, record.callId];
            NSArray* existRecordsId = [_db querySql:sql withParameters: nil];
            if ([existRecordsId count] > 0) {
                // update
                for (int i=0; i < [existRecordsId count]; i++) {
                    [dic removeObjectForKey:kHistoryRecordId];
                    [_db updateRow:dic toTable:@"history_record" index:[[existRecordsId[i] objectForKey:@"id"] intValue]];
                }
            } else {
                // add
                serverMissCount++;
                [dic removeObjectForKey:kHistoryRecordId];
                [_db insertRow:dic toTable:@"history_record"];
            }
        }
        [_db commitTransaction];
    }
    @catch (NSException *exception) {
        [_db rollbackTransaction];
    }
    @finally {
        [_db close];
    }
    
    // For icon Badge update
    if (serverMissCount > _localMissCallCount) {
        _unViewedMissCount = _unViewedMissCount + serverMissCount - _localMissCallCount;
        _missCountDirty = YES;
        [self store];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kMissedCallUpdated object:nil];
}
@end
