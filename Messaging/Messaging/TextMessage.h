//
//  TextMessage.h
//  Messaging
//
//  Created by ThemisKing on 7/22/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _TextMessageType{
    eSent = 1,
    eReceived
} TextMessageType;

@interface TextMessage : NSObject

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *peerId;
@property (nonatomic) TextMessageType type;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *timestamp;

@end
