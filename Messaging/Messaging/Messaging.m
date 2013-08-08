//
//  Messaging.m
//  Messaging
//
//  Created by Yao Melo on 5/22/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "Messaging.h"
#import "SocketIOPacket.h"
#import "Message.h"
#import "TextMessage.h"
#import "ParamsMessage.h"
#import "PresenceMessage.h"

#define ID_PREFIX @"test-"

@interface Messaging ()
@property (nonatomic, retain) SocketIO * chatSockIO;
@property (nonatomic, retain) NSString * host;
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) NSString * userToken;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, retain) NSMutableArray * msgWaitingAckArray;
@property NSInteger msgCount;
@property BOOL isReconnectNeed;
@end

@implementation Messaging
@synthesize chatSockIO = _chatSockIO;
@synthesize host = _host;
@synthesize userId = _userId;
@synthesize userToken = _userToken;
@synthesize port = _port;
@synthesize isReconnectNeed = _isReconnectNeed;

static Messaging* sharedMessageInstance = nil;

- (id)init {
    if ((self = [super init])) {
        //setup request management objects
        _chatSockIO = nil;
        _host = @"";
        _userId = nil;
        _userToken = @"";
        _port = 0;
        _msgWaitingAckArray = [[NSMutableArray alloc] init];
        _msgCount = 0;
    }
    return self;
}

+(Messaging*) sharedInstance
{
    @synchronized(self)
    {
        if(sharedMessageInstance == nil)
        {
            sharedMessageInstance = [[Messaging alloc] init];
        }
        return sharedMessageInstance;
    }
}

#pragma mark -
#pragma mark Server connection
-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withParams:(NSDictionary *)params withNamespace:(NSString *)endpoint{
    if (!self.chatSockIO) {
        self.chatSockIO = [[SocketIO alloc] initWithDelegate:self];
    }
    NSMutableDictionary* urlParams = [[NSMutableDictionary alloc] init];
    [params enumerateKeysAndObjectsUsingBlock: ^(id key, id value, BOOL *stop) {
        [urlParams setObject:[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:key];
    }];
    [self.chatSockIO connectToHost:host onPort:port withParams:urlParams withNamespace:endpoint];
}

-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withParams:(NSDictionary *)params
{
    if (!self.chatSockIO) {
        self.chatSockIO = [[SocketIO alloc] initWithDelegate:self];
    }
    NSMutableDictionary* urlParams = [[NSMutableDictionary alloc] init];
    [params enumerateKeysAndObjectsUsingBlock: ^(id key, id value, BOOL *stop) {
        [urlParams setObject:[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:key];
    }];
//    [urlParams setObject:self.userId forKey:@"uid"];
    [self.chatSockIO connectToHost:host onPort:port withParams:urlParams];
}

-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withToken:(NSString *)token userID:(NSString *)userID
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:token, @"token", userID, @"uid", nil];
    self.host = host;
    self.port = port;
    self.userId = userID;
    self.userToken = token;
    self.isReconnectNeed = YES;
    [self connectToMsgServer:host onPort:port withParams:params];
}

-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withToken:(NSString *)token userID:(NSString *)userID NeedReconnect:(BOOL)retry
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:token, @"token", userID, @"uid", nil];
    self.host = host;
    self.port = port;
    self.userId = userID;
    self.userToken = token;
    self.isReconnectNeed = retry;
    [self connectToMsgServer:host onPort:port withParams:params];
}

-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withToken:(NSString *)token userID:(NSString *)userID withNamespace:(NSString *)endpoint
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:token, @"token", userID, @"uid", nil];
    self.host = host;
    self.port = port;
    self.userId = userID;
    self.userToken = token;
    self.isReconnectNeed = YES; 
    [self connectToMsgServer:host onPort:port withParams:params withNamespace:endpoint];
}

-(void)reconnectMsgServer {
    [self connectToMsgServer:self.host onPort:self.port withToken:self.userToken userID:self.userId];
}

-(void)disconnectMsgServer {
    self.isReconnectNeed = NO;
    [self.chatSockIO disconnect];
}

-(Message *)findMsgWithID:(NSString*) messageID {
    for (Message* msg in self.msgWaitingAckArray) {
        if ([msg.msgID isEqual:messageID]) {
            return msg;
        }
    }
    return nil;
}

-(void)sendMsg:(Message*)msg {
    if (msg.needAck) {
        SocketIOCallback cb = ^(id argsData) {
            NSDictionary *response = argsData;
            // TODO: do something with response
            NSLog(@"SocketIOCallback response");
            // TODO: objectForKeyFailedOnNull
            NSInteger code = [[response valueForKey:@"code"] intValue];
            NSString * msgID = [response valueForKey:@"id"];
            Message* msg = [self findMsgWithID:msgID];
            if (msg) {
                if (code) {
                    // TODO: Notification or Re-send
                } else {
                    // Remove from waiting list
                    [self.msgWaitingAckArray removeObject:msg];
                    NSLog(@"Array count %d", self.msgWaitingAckArray.count);
                }
            }   
        };
        self.msgCount++;
        msg.msgID = [NSString stringWithFormat:@"%@%d", ID_PREFIX, self.msgCount];
        [_msgWaitingAckArray addObject:msg];
        [self.chatSockIO sendEvent:msg.type withData:msg.data andAcknowledge:cb];
    } else {
        [self.chatSockIO sendEvent:msg.type withData:msg.data];
    }
}

-(void)requestUserList {

    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"user-list", @"name", nil];
    ParamsMessage *msg = [[ParamsMessage alloc] initWithParams:dic andType:@"r"];
    msg.needAck = YES;
    [self sendMsg:msg];
}


-(void)sendChatMessage:(ChatContent *)textMsg {

    if (textMsg.peerId && textMsg.text) {
        TextMessage *msg = [[TextMessage alloc] init];
        msg.content = textMsg;
        msg.needAck = YES;
        [self sendMsg:msg];
    }
}

#pragma mark -
#pragma mark SocketIODelegate
- (void) socketIODidConnect:(SocketIO *)socket {
    NSLog(@"socketIODidConnect");
    [[NSNotificationCenter defaultCenter] postNotificationName:kSocketServerConnected object:nil];
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"socketIODidDisconnect");
    if (self.isReconnectNeed) {
        [self performSelector:@selector(reconnectMsgServer) withObject:nil afterDelay:10];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSocketServerDisconnected object:nil];
    }
}

- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    NSLog(@"didReceiveMessage");
}

- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
    NSLog(@"didReceiveJSON, %@", packet.data);
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    NSLog(@"didReceiveEvent %@", packet.data);
    NSDictionary *event = [packet dataAsJSON];
    NSString *type = [event objectForKey:@"name"];
    
    if ([type isEqual:TYPE_TEXT]) {
        NSArray *msgInfo = [event objectForKey:@"args"];
        for(NSDictionary* msgDic in msgInfo)
        {
            ChatContent * chat = [ChatContentBuilder buildFromDict:msgDic];
            chat.userId = self.userId;
            chat.type = eChatIncoming;
            TextMessage *msg = [[TextMessage alloc]init];
            msg.content = chat;
            [[NSNotificationCenter defaultCenter] postNotificationName:kSocketServerMsgReceived object:msg];
        }
    }
    else if ([type isEqual:TYPE_NOTIFICATION]) {
         NSArray *msgInfo = [event objectForKey:@"args"];
        for(NSDictionary* msgDic in msgInfo)
        {
            NSString* notType = [msgDic objectForKey:@"type"];
            if([notType isEqualToString:NOTIFICATION_PRESENCE])
            {
                PresenceMessage* pmsg = [[PresenceMessage alloc] initWithUserId:[msgDic objectForKey:@"user_id"] status:[[msgDic objectForKey:@"status"]integerValue] devices:[msgDic objectForKey:@"device"] timestamp:[msgDic objectForKey:@"ts"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:kSocketServerMsgReceived object:pmsg];
            }
        }
    }
    else if ([type isEqual:TYPE_CONTROL]) {
    }
 
}

- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet {
    NSLog(@"didSendMessage %@", packet.data);
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error {
    NSLog(@"onError");
}

@end
