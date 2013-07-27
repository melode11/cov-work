//
//  SAJSONv2LoginAgent.h
//  ServerAgents
//
//  Created by Yao Melo on 7/18/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "SAJSONv2HttpAgent.h"
#import "SABizProtocols.h"

@class ServerModel;

@interface SAJSONv2LoginAgent : SAJSONv2HttpAgent<SALoginProtocol>

@property (nonatomic,retain) NSString* token;
@property (nonatomic,retain) ServerModel* messagingServer;
@property (nonatomic,retain) NSString* userName;
@property (nonatomic,retain) NSString* displayName;
@property (nonatomic,assign) NSInteger userId;

@end
