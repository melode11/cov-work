//
//  ChatContentBuilder.m
//  Utilities
//
//  Created by Yao Melo on 7/30/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "ChatContentBuilder.h"
#import "NSDictionary+SafeAccess.h"
#import "DTConstants.h"

@implementation ChatContentBuilder

+(ChatContent *)buildFromDict:(NSDictionary *)dict
{
    ChatContent *cc = [[ChatContent alloc]init];
    cc.peerId = [dict objectForKeyNullToNil:kChatContentPeerId];//keep align with server key.
    cc.text = [dict objectForKeyNullToNil:kChatContentText];
    cc.timestamp = [[dict objectForKeyNullToNil:kChatContentTimestamp] longLongValue]/1000.0;
    cc.userId = [dict objectForKeyNullToNil:kChatContentUserId];//customized key in client side.
    NSNumber *type = [dict objectForKeyNullToNil:kChatContentType];
    if(type)
    {
        cc.type = [type integerValue];
    }
    return [cc autorelease];
    
}

+(NSDictionary *)toDictionary:(ChatContent *)cc
{
    return [NSDictionary dictionaryWithObjectsAndKeys:cc.userId,kChatContentUserId,cc.peerId,kChatContentPeerId,cc.text,kChatContentText,[NSNumber numberWithLongLong:(1000*cc.timestamp)],kChatContentTimestamp,[NSNumber numberWithInteger:cc.type],kChatContentType, nil];
}

@end
