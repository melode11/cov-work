//
//  ServiceAgentsFactory.m
//  ServerAgents
//
//  Created by Yao Melo on 7/18/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "ServerAgentsFactory.h"
#import "Utilities/constants.h"
#import "SAv2ServiceLocator.h"
#import "SAJSONv2LoginAgent.h"
#import "SAJSONv2UserListAgent.h"

@implementation ServerAgentsFactory
@synthesize serviceLocator = _serviceLocator;

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
            id<SAServiceLocator> slocator = [[SAv2ServiceLocator alloc] init];
            _sharedSAFactoryInstance.serviceLocator = slocator;
            [_sharedSAFactoryInstance resetServiceLocator];
            [slocator release];
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

-(id<SALoginProtocol>)createLoginAgentWithDelegate:(id<SADelegate>)delegate
{
    SAJSONv2LoginAgent* agent = [[SAJSONv2LoginAgent alloc] initWithDelegate:delegate andServiceLocator:_serviceLocator];
    return [agent autorelease];
}

-(id<SAUserListProtocol>)createUserListAgentWithDelegate:(id<SADelegate>)delegate
{
    SAJSONv2UserListAgent* agent = [[SAJSONv2UserListAgent alloc] initWithDelegate:delegate andServiceLocator:_serviceLocator];
    return [agent autorelease];
}

- (void)dealloc
{
    [_serviceLocator release];
    [super dealloc];
}

@end
