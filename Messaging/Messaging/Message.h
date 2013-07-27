//
//  TextMessage.h
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

@interface Message : NSObject {
    NSString* _type;
    NSString* _msgID;
    NSMutableDictionary* _data;
    BOOL _needAck;
    NSArray* _types;
}

@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSMutableDictionary* data;
@property (nonatomic, retain) NSString* msgID;
@property BOOL needAck;

- (id) init;
- (id) initWithTypeIndex:(int)index;

@end
