//
//  ServiceAgentsFactory.h
//  ServerAgents
//
//  Created by Yao Melo on 7/18/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAConstants.h"
#import "SABizProtocols.h"

@interface ServerAgentsFactory : NSObject

@property (nonatomic,retain) id<SAServiceLocator> serviceLocator;

+(ServerAgentsFactory*) sharedInstance;
+(void) registerFactory:(Class)factoryClass;

- (void)resetServiceLocator;

-(id<SALoginProtocol>)createLoginAgentWithDelegate:(id<SADelegate>)delegate;

-(id<SAUserListProtocol>)createUserListAgentWithDelegate:(id<SADelegate>)delegate;

@end