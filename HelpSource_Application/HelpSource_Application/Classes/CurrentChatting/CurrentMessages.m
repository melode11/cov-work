//
//  CurrentMessages.m
//  HelpSource_Application
//
//  Created by ThemisKing on 8/6/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "CurrentMessages.h"

@implementation CurrentMessages

-(id)initWithPeerId:(NSInteger)userId {
    self = [super init];
    if(self)
    {
        _peerId = userId;
        _messages = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)insertMessage:(ChatContent *)msg {
    if (msg) {

        if ([self.messages count] >0) {
            id mySort = ^(ChatContent * content1, ChatContent * content2) {
                NSTimeInterval ts1 = content1.timestamp;
                NSTimeInterval ts2 = content2.timestamp;
                return ts1<ts2?NSOrderedAscending:ts1 == ts2?NSOrderedSame:NSOrderedDescending;
            };
            
            NSInteger index = [self.messages indexOfObject:msg inSortedRange:NSMakeRange(0, [self.messages count]) options: NSBinarySearchingInsertionIndex usingComparator:mySort];
            [self.messages insertObject:msg atIndex:index];
        }
        else
        {
            [self.messages addObject:msg];
        }
    }
}

-(void)dealloc
{
    [_messages release];
    [super dealloc];
}

@end
