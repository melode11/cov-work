//
//  ServerAgentsManager.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ServerAgentsFactory.h"
#import "SAJSONPhoneBookAgent.h"
#import "SADefaultServiceLocator.h"
#import "SAJSONProductGroupAgent.h"
#import "SAJSONUserInfoAgent.h"
#import "SAJSONFileUploadAgent.h"
#import "SAWebAuthenticationAgent.h"
#import "SAJSONSipInfoAgent.h"
#import "SAJSONAppVersionAgent.h"
#import "SAJSONSecureModelAgent.h"
#import "SAJSONMissedCallAgent.h"
#import "constants.h"

NSString *const SERVICE_PHONEBOOK = @"phonebook";
NSString *const SERVICE_PRODUCTGROUP = @"productgroup";
NSString *const SERVICE_USERINFO = @"userinfo";
NSString *const SERVICE_EXTRAINFO = @"extrainfo";
NSString *const SERVICE_WEBAUTHENTICATE = @"webauth";
NSString *const SERVICE_FILEUPLOAD = @"uploadfile";
NSString *const SERVICE_SIPINFO = @"sipinfo";
NSString *const SERVICE_CRMODUPLOAD = @"uploadcrmodfile";
NSString *const SERVICE_APPVERSION = @"appversion";
NSString *const SERVICE_SECUREMODEL = @"securemodel";
// AURORA-1712
NSString *const SERVICE_UPLOADMC = @"uploadmissedcall";
NSString *const SERVICE_DOWNLOADMC = @"downloadmissedcall";
NSString *const SERVICE_CONFIRMMC = @"downloadedmissedcall";
NSString *const SERVICE_CLEARMC = @"clearmissedcall";
NSString *const SERVICE_LOGIN = @"login";

NSInteger const SA_ERR_USERINFO_GROUP_NOT_FOUND = 100;
NSInteger const SA_ERR_USERINFO_NAME_TOO_LONG = 101;
NSInteger const SA_ERR_USERINFO_LOCKUSER = 102;
NSInteger const SIP_ERROR_NOT_REGISTER = 103;

@implementation ServerAgentsFactory
@synthesize serviceLocator;

static Class _factoryClass;

static ServerAgentsFactory* _sharedSAFactoryInstance = nil;

+(void)initialize
{
    _factoryClass = [ServerAgentsFactory class];
}

+(ServerAgentsFactory*) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedSAFactoryInstance == nil)
        {
            _sharedSAFactoryInstance = [[_factoryClass alloc] init];
        }
        //retain-autorelease prevents unexpected deallocation by registerFactory call in another thread.
        return [[_sharedSAFactoryInstance retain] autorelease];
    }
}

+(void) registerFactory:(Class)factoryClass
{
    @synchronized(self)
    {
        if([factoryClass isSubclassOfClass:[ServerAgentsFactory class]])
        {
            _factoryClass = factoryClass;
            [_sharedSAFactoryInstance release];
            _sharedSAFactoryInstance = nil;
        }
    }
}

- (void)resetServiceLocator
{
    if([self.serviceLocator respondsToSelector:@selector(setBaseUrl:)])
    {
        [self.serviceLocator performSelector:@selector(setBaseUrl:) withObject:[[NSUserDefaults standardUserDefaults] stringForKey:kSessionServerIPKey]];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        SADefaultServiceLocator* locator = [SADefaultServiceLocator sharedInstance];
        locator.baseUrl = [[NSUserDefaults standardUserDefaults] stringForKey:kSessionServerIPKey];

        self.serviceLocator = locator;

    }
    return self;
}

-(id<SAPhoneBookProtocol>)createPhoneBookAgentWithDelegate:(id<SADelegate>)delegate
{
    return [[[SAJSONPhoneBookAgent alloc]initWithDelegate:delegate andServiceLocator:self.serviceLocator] autorelease];
}

-(id<SAProductGroupProtocol>)createProductGroupAgentWithDelegate:(id<SADelegate>)delegate
{
    return [[[SAJSONProductGroupAgent alloc]initWithDelegate:delegate andServiceLocator:self.serviceLocator] autorelease]; 
}

-(id<SAUserInfoProtocol>)createUserInfoAgentWithDelegate:(id<SADelegate>)delegate
{
    return [[[SAJSONUserInfoAgent alloc]initWithDelegate:delegate andServiceLocator:self.serviceLocator]autorelease];
}

-(id<SAWebAuthenticateProtocol>)createWebAuthenticationAgentWithDelegate:(id<SADelegate>)delegate
{
    return [[[SAWebAuthenticationAgent alloc]initWithDelegate:delegate andServiceLocator:self.serviceLocator]autorelease];
}

-(id<SAFileUploadProtocol>)createFileUploadAgentWithDelegate:(id<SADelegate>)delegate
{
    return [[[SAJSONFileUploadAgent alloc]initWithDelegate:delegate andServiceLocator:self.serviceLocator]autorelease];
}

-(id<SASipInfoProtocol>)createSipInfoAgentWithDelegate:(id<SADelegate>)delegate
{
    return [[[SAJSONSipInfoAgent alloc]initWithDelegate:delegate andServiceLocator:self.serviceLocator]autorelease];
}

-(id<SAAppVersionProtocol>)createAppVersionAgentWithDelegate:(id<SADelegate>)delegate
{
    return [[[SAJSONAppVersionAgent alloc]initWithDelegate:delegate andServiceLocator:self.serviceLocator]autorelease];
}

-(id<SASecureModelProtocol>)createSecureModelAgentWithDelegate:(id<SADelegate>)delegate
{
    return [[[SAJSONSecureModelAgent alloc]initWithDelegate:delegate andServiceLocator:self.serviceLocator]autorelease];
}

// AURORA-1712
-(id<SAMissedCallProtocol>)createMissedCallAgentWithDelegate:(id<SADelegate>)delegate
{
    return [[[SAJSONMissedCallAgent alloc]initWithDelegate:delegate andServiceLocator:self.serviceLocator]autorelease];
}
@end
