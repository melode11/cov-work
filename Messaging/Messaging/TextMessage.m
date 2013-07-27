//
//  TextMessage.m
//  Messaging
//
//  Created by ThemisKing on 7/22/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "TextMessage.h"

@implementation TextMessage

@synthesize userId;
@synthesize peerId;
@synthesize type;
@synthesize text;
@synthesize timestamp;

- (id)init
{
    self = [super init];
    if (self) {
        userId = nil;
        peerId = nil;
        type = eSent;
        text = nil;
        timestamp = 0;
    }
    return self;
}

@end
