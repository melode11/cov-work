//
//  PresenceMessage.h
//  Messaging
//
//  Created by Yao Melo on 7/30/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "NotificationMessage.h"

@interface PresenceMessage : NotificationMessage

@property (nonatomic,readonly) NSInteger status;

@property (nonatomic,readonly) NSString* timestamp;

@property (nonatomic,readonly) NSString* userId;

@property (nonatomic,readonly) NSArray* devices;

-(id)initWithUserId:(NSString*)userId status:(NSInteger) status devices:(NSArray*)devices timestamp:(NSString*) ts;

@end
