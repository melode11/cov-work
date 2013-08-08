//
//  NotificationMessage.h
//  Messaging
//
//  Created by Yao Melo on 7/30/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "Message.h"
extern NSString * const NOTIFICATION_PRESENCE;

@interface NotificationMessage : Message

@property (nonatomic,readonly) NSString* notificationType;

@end
