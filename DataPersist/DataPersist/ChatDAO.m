//
//  ChatDAO.m
//  DataPersist
//
//  Created by Yao Melo on 8/8/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "ChatDAO.h"
#import "Utilities/DTConstants.h"
#import "SqliteDatabasePool.h"
#import "Utilities/ChatContentBuilder.h"

#define kChatHistoryFile @"helpsource"
@interface TimestampEntry:NSObject
{
    @public
    NSTimeInterval timestamp;
    BOOL isDirty;
}
@end

@implementation TimestampEntry


@end

@interface ChatDAO()
-(TimestampEntry*)entryForPeerId:(NSString*)peerId;
@end

@implementation ChatDAO

-(id)initWithPath:(NSString *)path
{
    self = [super init];
    if(self)
    {
        _db = [[[SqliteDatabasePool sharedInstance] getDatabaseWithPath:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",kChatHistoryFile]]] retain];
        [_db open];
        NSArray *columnDescriptors = [NSArray arrayWithObjects:[SqliteColumnDescriptor descriptorWithColumnName:kChatContentUserId andType:eColumnTypeText],
                                      [SqliteColumnDescriptor descriptorWithColumnName:kChatContentPeerId andType:eColumnTypeText],
                                      [SqliteColumnDescriptor descriptorWithColumnName:kChatContentTimestamp andType:eColumnTypeInteger],
                                      [SqliteColumnDescriptor descriptorWithColumnName:kChatContentType andType:eColumnTypeInteger],
                                      [SqliteColumnDescriptor descriptorWithColumnName:kChatContentText andType:eColumnTypeText],
                                      nil];
        [_db createNotExistTableWithName:@"chat_record" primaryKey:@"id" columnDescriptors:columnDescriptors];
        [_db close];
        _lastTimestampCache = [[NSMutableDictionary alloc] init];
        [self load];
    }
    return self;
}

-(TimestampEntry*)entryForPeerId:(NSString*)peerId
{
    TimestampEntry *entry = [_lastTimestampCache objectForKey:peerId];
    if(entry == nil)
    {
        entry = [[TimestampEntry alloc] init];
        [_lastTimestampCache setObject:entry forKey:peerId];
        [entry release];
    }
    return entry;
}

-(NSInteger)messagesWithPeer:(NSString *)peerId earlierThan:(NSTimeInterval)timestamp withMaxCount:(NSInteger)maxCount appendTo:(NSMutableArray *)outArray
{
    [_db open];
    NSInteger count = 0;
    NSArray* array = [_db querySql:[NSString stringWithFormat:@"select id,%@,%@,%@,%@,%@ from chat_record where %@=? and %@<? order by %@ asc limit ?",kChatContentUserId, kChatContentPeerId,kChatContentTimestamp,kChatContentType,kChatContentText,kChatContentPeerId,kChatContentTimestamp,kChatContentTimestamp] withParameters:peerId,[NSNumber numberWithLongLong:1000*timestamp],[NSNumber numberWithInteger:maxCount], nil];
    count = [array count];
    
    for (NSDictionary* dic in array) {
        ChatContent* chat = [ChatContentBuilder buildFromDict:dic];
        [outArray addObject:chat];
    }

    //update the lasttimestamp by the way.
    TimestampEntry* entry = [self entryForPeerId:peerId];
    if (entry->isDirty) {
        if(count>0)
        {
            NSNumber* number = [[array objectAtIndex:count-1] objectForKey:kChatContentTimestamp];
            if(number)
            {
                entry->timestamp = [number longLongValue]/1000.0;
            }
        }
        else
        {
            entry->timestamp = 0;
        }
        entry->isDirty = NO;
    }
    
    [_db close];
    return count;
}

-(NSTimeInterval)latestTimestampWithPeer:(NSString *)peer
{
    TimestampEntry* entry = [self entryForPeerId:peer];
    if (entry->isDirty) {
        [_db open];
        NSArray* array = [_db querySql: [NSString stringWithFormat:@"select max(%@) from chat_record where %@=?",kChatContentTimestamp,kChatContentPeerId] withParameters:peer, nil];
        NSTimeInterval tmp = 0;
        if([array count] > 0)
        {
            NSNumber* number = [[array objectAtIndex:0] objectForKey:kChatContentTimestamp];
            if(number)
            {
                tmp = [number longLongValue]/1000.0;
            }
            
        }
        entry->timestamp = tmp;
        entry->isDirty = NO;
        [_db close];
    }
    return entry->timestamp;
}

-(void)addChatMessages:(NSArray*) chatMsgs;
{
    @try {
        [_db open];
        [_db beginTransaction];
        NSString *currentPeerId = nil;
        for (ChatContent* cc in chatMsgs) {
            NSAssert([cc isKindOfClass:[ChatContent class]],@"Trying to insert illegal element,must be instance of ChatContent");
            if(![currentPeerId isEqualToString:cc.peerId])
            {
                currentPeerId = cc.peerId;
                [self entryForPeerId:currentPeerId]->isDirty = YES;
            }
            [_db insertRow:[ChatContentBuilder toDictionary:cc] toTable:@"chat_record"];
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

-(void)addChatMessage:(ChatContent*) chatMsg
{
    [_db open];
    [self entryForPeerId:chatMsg.peerId]->isDirty = YES;
    [_db insertRow:[ChatContentBuilder toDictionary:chatMsg] toTable:@"chat_record"];
    [_db close];
}

-(void)store
{
    //empty
}

-(void)clean
{
    [_db open];
    [_db executeSql:@"delete from history_record" withParameters: nil];
    [_db close];
    [_lastTimestampCache removeAllObjects];
}

-(void)load
{
    //nothing to load right now
}

-(void)dealloc
{
    [_db release];
    [_lastTimestampCache release];
    [super dealloc];
}

@end
