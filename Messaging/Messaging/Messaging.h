//
//  Messaging.h
//  Messaging
//
//  Created by Yao Melo on 5/22/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"
#import "TextMessage.h"

#define kSocketServerConnected @"socketServerConnected"
#define kSocketServerDisconnected @"socketServerDisconnected"
#define kSocketServerMsgReceived @"socketServerMsgReceived"

@class Message;
@class TextMessage;
@interface Messaging : NSObject <SocketIODelegate> {
    SocketIO * _chatSockIO;
    NSString * _userId;
}

+(Messaging*) sharedInstance;

//-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withParams:(NSDictionary *)params;
//-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withParams:(NSDictionary *)params withNamespace:(NSString *)endpoint;
-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withToken:(NSString *)token userID:(NSString *)userID;
-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withToken:(NSString *)token userID:(NSString *)userID withNamespace:(NSString *)endpoint;
-(void)disconnectMsgServer;

-(void)sendMsg:(Message *)msg;
-(void)requestUserList;
-(void)sendTextMessage:(TextMessage *)textMsg;
//-(void)sendTextMessage:(NSString *)text to:(NSInteger)userID;
//-(void)sendControl
@end
