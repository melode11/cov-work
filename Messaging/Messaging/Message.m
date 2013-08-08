//
//  Message.m
//  Messaging
//
//  Created by ThemisKing on 7/17/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "Message.h"
NSString * const TYPE_TEXT = @"t";
NSString * const TYPE_CONTROL = @"c";
NSString * const TYPE_REQUEST = @"r";
NSString * const TYPE_NOTIFICATION = @"n";

static NSArray* _types = NULL;

@interface Message ()
@property (nonatomic, retain) NSArray* types;
@end

@implementation Message

+(void)initialize
{
    _types = [NSArray arrayWithObjects: TYPE_CONTROL, TYPE_TEXT, TYPE_REQUEST, TYPE_NOTIFICATION, nil];
}

- (id)init {
    if ((self = [super init])) {
        _needAck = NO;
        _msgID = nil;
    }
    return self;
}

- (NSString *) typeForIndex:(int)index
{
    return [_types objectAtIndex:index];
}

-(NSString *)type
{
    return nil;
}

-(NSDictionary *)data
{
    return nil;
}

@end
