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

#define ID_PREFIX @"test-"

@interface Messaging ()
@property (nonatomic, retain) SocketIO * chatSockIO;
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) NSMutableArray * msgWaitingAckArray;
@property NSInteger msgCount;
@end

@implementation Messaging
@synthesize chatSockIO = _chatSockIO;
@synthesize userId = _userId;

static Messaging* sharedMessageInstance = nil;

- (id)init {
    if ((self = [super init])) {
        //setup request management objects
        _chatSockIO = nil;
        _msgWaitingAckArray = [[NSMutableArray alloc] init];
        _msgCount = 0;
        _userId = nil;
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
    [self.chatSockIO connectToHost:host onPort:port withParams:urlParams];
}

-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withToken:(NSString *)token userID:(NSString *)userID
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:token, @"token", nil];
    self.userId = userID;
    [self connectToMsgServer:host onPort:port withParams:params];
}

-(void)connectToMsgServer:(NSString*)host onPort:(NSInteger)port withToken:(NSString *)token userID:(NSString *)userID withNamespace:(NSString *)endpoint
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:token, @"token", nil];
    self.userId = userID;
    [self connectToMsgServer:host onPort:port withParams:params withNamespace:endpoint];
}

-(void)disconnectMsgServer {
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
        [msg.data setObject:msg.msgID forKey:@"id"];
        [_msgWaitingAckArray addObject:msg];
        [self.chatSockIO sendEvent:msg.type withData:msg.data andAcknowledge:cb];
    } else {
        [self.chatSockIO sendEvent:msg.type withData:msg.data];
    }
}

-(void)requestUserList {
    Message *msg = [[Message alloc] init];
    msg.type = @"r";
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"user-list", @"name", nil];
    msg.data = dic;
    msg.needAck = YES;
    [self sendMsg:msg];
}

-(void)sendTextMessage:(NSString*)text to:(NSInteger)userID {
    Message *msg = [[Message alloc] init];
    msg.type = @"t";
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", userID], @"user_id", text, @"text",  nil];
    msg.data = dic;
    msg.needAck = YES;
    [self sendMsg:msg];
}

-(void)sendTextMessage:(TextMessage *)textMsg {
    Message *msg = [[Message alloc] init];
    if (textMsg.peerId && textMsg.text) {
        msg.type = @"t";
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", [textMsg.peerId intValue]], @"user_id", textMsg.text, @"text",  nil];
        msg.data = dic;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kSocketServerDisconnected object:nil];
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
    
    if ([type isEqual:@"t"]) {
        NSArray *msgInfo = [event objectForKey:@"args"];
        
        TextMessage * textMsg = [[TextMessage alloc] init];
        textMsg.userId = self.userId;
        textMsg.peerId = [[msgInfo valueForKey:@"user_id"] lastObject];
        textMsg.text = [[msgInfo valueForKey:@"text"] lastObject];
        textMsg.timestamp = [[msgInfo valueForKey:@"ts"] lastObject];
        textMsg.type = eReceived;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSocketServerMsgReceived object:textMsg];
    } else if ([type isEqual:@"n"]) {
        
    }
}

- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet {
    NSLog(@"didSendMessage %@", packet.data);
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error {
    NSLog(@"onError");
}

@end
