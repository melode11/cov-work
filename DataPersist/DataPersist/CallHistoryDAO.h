//
//  CallHistoryDAO.h
//  AuroraPhone
//
//  Created by Yao Melo on 11/14/12.
//
//

#import "BaseDAO.h"
#import "Utilities/HistoryRecordBuilder.h"
#import "SqliteDatabaseWrapper.h"

@interface CallHistoryDAO : BaseDAO
{
    SqliteDatabaseWrapper* _db;
    NSInteger _unViewedMissCount;
    NSInteger _localMissCallCount;
    BOOL _missCountDirty;
}

@property(nonatomic) NSInteger unViewedMissCount;
@property(nonatomic) NSInteger localMissCallCount;

-(id)initWithPath:(NSString*) path;

-(void)addHistoryRecord:(HistoryRecord*) record;

-(NSArray*)allRecords;

-(NSArray*) filteredRecords:(BOOL(^)(HistoryRecord*)) filterBlock;

-(void)removeHistoryRecords:(NSArray*) records;

// Need store after reset
-(void)resetMissCount;

-(void)updateMissedCallRecords:(NSArray*)records;

//we may have this method in future to support history detail
//-(NSArray*)recordItemsFor:(HistoryRecord*) record;

@end
