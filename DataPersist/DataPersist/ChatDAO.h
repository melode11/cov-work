//
//  ChatDAO.h
//  DataPersist
//
//  Created by Yao Melo on 8/8/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "BaseDAO.h"
#import "Utilities/ChatContent.h"
@class SqliteDatabaseWrapper;

@interface ChatDAO : BaseDAO
{
    SqliteDatabaseWrapper* _db;

    NSMutableDictionary* _lastTimestampCache;
}

-(id)initWithPath:(NSString *)path;

-(NSInteger)messagesWithPeer:(NSString*)peerId earlierThan:(NSTimeInterval) timestamp withMaxCount:(NSInteger)maxCount appendTo:(NSMutableArray*)outArray;

-(NSTimeInterval)latestTimestampWithPeer:(NSString*)peer;

-(void)addChatMessages:(NSArray*) chatMsgs;

-(void)addChatMessage:(ChatContent*) chatMsg __deprecated; 

@end
