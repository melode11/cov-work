//
//  Messaging.h
//  Messaging
//
//  Created by Yao Melo on 5/22/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"
#import "Utilities/ChatContent.h"

#define kSocketServerConnected @"socketServerConnected"
#define kSocketServerDisconnected @"socketServerDisconnected"
#define kSocketServerMsgReceived @"socketServerMsgReceived"

@class Message;
@class TextMessage;
@interface Messaging : NSObject <SocketIODelegate> {
    SocketIO * _chatSockIO;
    NSString * _host;
    NSString * _userId;
    NSString * _userToken;
    NSInteger _port;
    BOOL _isReconnectNeed;
}

+(Messaging*) sharedInstance;

-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withToken:(NSString *)token userID:(NSString *)userID;
-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withToken:(NSString *)token userID:(NSString *)userID NeedReconnect:(BOOL)retry;
-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withToken:(NSString *)token userID:(NSString *)userID withNamespace:(NSString *)endpoint;
-(void)disconnectMsgServer;

-(void)sendMsg:(Message *)msg;
-(void)requestUserList;
-(void)sendChatMessage:(ChatContent *)chatMsg;
//-(void)sendControl
@end
