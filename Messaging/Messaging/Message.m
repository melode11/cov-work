//
//  TextMessage.m
//  Messaging
//
//  Created by ThemisKing on 7/17/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "Message.h"
@interface Message ()
@property (nonatomic, retain) NSArray* types;
@end

@implementation Message
@synthesize type = _type;
@synthesize needAck = _needAck;
@synthesize data = _data;
@synthesize types = _types;
@synthesize msgID = _msgID;

- (id)init {
    if ((self = [super init])) {
        _type = nil;
        _needAck = NO;
        _data = nil;
        _msgID = nil;
        _types = [NSArray arrayWithObjects: @"c", @"t", @"r", @"n", nil];
    }
    return self;
}

- (NSString *) typeForIndex:(int)index
{
    return [_types objectAtIndex:index];
}

- (id) initWithTypeIndex:(int)index
{
    self = [self init];
    if (self) {
        self.type = [self typeForIndex:index];
    }
    return self;
}


@end
