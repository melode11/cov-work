//
//  ChatContent.m
//  Utilities
//
//  Created by Yao Melo on 7/30/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "ChatContent.h"

@implementation ChatContent

- (id)init
{
    self = [super init];
    if (self) {
        _type = eChatOutgoing;
    }
    return self;
}

- (void)dealloc
{
    [_userId release];
    [_peerId release];
    [_text release];
    [super dealloc];
}

@end
