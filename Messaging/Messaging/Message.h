//
//  Message.h
//  Messaging
//
//  Created by ThemisKing on 7/17/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _MessageType{
    eNullMsg = -1,
    eControlMsg,
    eTextMsg,
    eRequestMsg,
    eNotificationMsg
} MessageType;

extern NSString * const TYPE_TEXT;
extern NSString * const TYPE_CONTROL;
extern NSString * const TYPE_REQUEST;
extern NSString * const TYPE_NOTIFICATION;

@interface Message : NSObject {

}

@property (nonatomic, readonly) NSString* type;
@property (nonatomic, readonly) NSDictionary* data;
@property (nonatomic, retain) NSString* msgID;
@property BOOL needAck;

- (id) init;

@end
