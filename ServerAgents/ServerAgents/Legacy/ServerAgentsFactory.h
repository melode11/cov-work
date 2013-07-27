//
//  ServerAgentsManager.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAConstants.h"
#import "SABizProtocols.h"

//business code
FOUNDATION_EXPORT NSInteger const SA_ERR_USERINFO_GROUP_NOT_FOUND;
FOUNDATION_EXPORT NSInteger const SA_ERR_USERINFO_NAME_TOO_LONG;
FOUNDATION_EXPORT NSInteger const SA_ERR_USERINFO_LOCKUSER;
FOUNDATION_EXPORT NSInteger const SIP_ERROR_NOT_REGISTER;

@interface ServerAgentsFactory : NSObject

@property (nonatomic,retain) id<SAServiceLocator> serviceLocator;

-(id<SAPhoneBookProtocol>) createPhoneBookAgentWithDelegate:(id<SADelegate>) delegate;

-(id<SAProductGroupProtocol>) createProductGroupAgentWithDelegate:(id<SADelegate>) delegate;

-(id<SAUserInfoProtocol>) createUserInfoAgentWithDelegate:(id<SADelegate>) delegate;

-(id<SAWebAuthenticateProtocol>)createWebAuthenticationAgentWithDelegate:(id<SADelegate>)delegate;

-(id<SAFileUploadProtocol>)createFileUploadAgentWithDelegate:(id<SADelegate>)delegate;

-(id<SASipInfoProtocol>)createSipInfoAgentWithDelegate:(id<SADelegate>)delegate;

-(id<SAAppVersionProtocol>)createAppVersionAgentWithDelegate:(id<SADelegate>)delegate;

-(id<SASecureModelProtocol>)createSecureModelAgentWithDelegate:(id<SADelegate>)delegate;

// AURORA-1712
-(id<SAMissedCallProtocol>)createMissedCallAgentWithDelegate:(id<SADelegate>)delegate;

+(ServerAgentsFactory*) sharedInstance;

+(void) registerFactory:(Class)factoryClass;

- (void)resetServiceLocator;

@end
