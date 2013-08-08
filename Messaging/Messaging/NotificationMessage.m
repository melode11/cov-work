//
//  NotificationMessage.m
//  Messaging
//
//  Created by Yao Melo on 7/30/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "NotificationMessage.h"
NSString * const NOTIFICATION_PRESENCE = @"presence";


@implementation NotificationMessage

-(NSString *)notificationType
{
    return nil;
}

-(NSString *)type
{
    return TYPE_NOTIFICATION;
}

@end
