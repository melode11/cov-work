//
//  CurrentChattingManager.m
//  HelpSource_Application
//
//  Created by ThemisKing on 8/6/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#include <AudioToolbox/AudioToolbox.h>

#import "CurrentChattingManager.h"
#import "CurrentMessages.h"
#import "Messaging/Messaging.h"
#import "Messaging/Message.h"
#import "Messaging/TextMessage.h"

static CurrentChattingManager* sharedInstance = nil;

@implementation CurrentChattingManager
@synthesize currentUser = _currentUser;

+(CurrentChattingManager *)sharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[CurrentChattingManager alloc] init];
    }
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if(self)
    {
        _chattingRecords = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceived:) name:kSocketServerMsgReceived object:nil];
    }
    return self;
}

-(void)dealloc
{
    [_chattingRecords release];
    [super dealloc];
}

-(CurrentMessages*)getCurrentMessagesWith:(NSInteger)peerId {
    for (CurrentMessages* msgs in self.chattingRecords) {
        if (msgs.peerId == peerId) {
            return msgs;
        }
    }
    return nil;
}

-(NSMutableArray*)getMessagesWith:(NSInteger)peerId {
    CurrentMessages* msgs = [self getCurrentMessagesWith:peerId];
    if (msgs) {
        return msgs.messages;
    } else {
        return [[[NSMutableArray alloc] init] autorelease];
    }
}

-(void)addMessage:(ChatContent*)msg with:(NSInteger)peerId {
    CurrentMessages* msgs = [self getCurrentMessagesWith:peerId];
    if (!msgs) {
        msgs = [[[CurrentMessages alloc] initWithPeerId:peerId] autorelease];
        [self.chattingRecords addObject:msgs];
    }
    [msgs insertMessage:msg];
}

-(void)messageReceived:(NSNotification*)notification {
    Message* msg  = notification.object;
    if ([msg.type isEqualToString:TYPE_TEXT]) {
        TextMessage* text = (TextMessage *)msg;
        if ([text.content.peerId intValue] != self.currentUser) {
            [self addMessage:text.content with:[text.content.peerId intValue]];
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
    }
}
@end
