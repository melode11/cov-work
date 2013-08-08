//
//  TextMessage.m
//  Messaging
//
//  Created by ThemisKing on 7/22/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "TextMessage.h"

@implementation TextMessage

- (id)init
{
    self = [super init];
    if (self) {
        _content = nil;
    }
    return self;
}

-(NSDictionary *)data
{
    return [[NSDictionary alloc] initWithObjectsAndKeys: _content.peerId, @"user_id", _content.text, @"text",  self.msgID,@"id", nil];

}

-(NSString *)type
{
    return TYPE_TEXT;
}

@end
