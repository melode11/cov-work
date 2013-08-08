//
//  PresenceMessage.m
//  Messaging
//
//  Created by Yao Melo on 7/30/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "PresenceMessage.h"

@implementation PresenceMessage
@synthesize userId = _userId;
@synthesize status = _status;
@synthesize timestamp = _timestamp;
@synthesize devices = _devices;

- (id)initWithUserId:(NSString *)userId status:(NSInteger)status devices:(NSArray *)devices timestamp:(NSString *)ts
{
    self = [super init];
    if (self) {
        _userId = userId;
        _status = status;
        _timestamp = ts;
        _devices = devices;
    }
    return self;
}

-(NSString *)userId
{
    return _userId;
}

-(NSInteger)status
{
    return _status;
}

-(NSString *)timestamp
{
    return _timestamp;
}

-(NSArray *)devices
{
    return _devices;
}

-(NSString *)notificationType
{
    return NOTIFICATION_PRESENCE;
}

@end
