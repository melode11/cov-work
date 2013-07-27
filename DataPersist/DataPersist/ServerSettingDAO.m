//
//  ServerSettingDAO.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-9-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ServerSettingDAO.h"
#import "Utilities/ServerModelBuilder.h"
#define SERVER_SETTING_KEY @"serversetting"

@implementation ServerSettingDAO

- (id)initWithImpl:(id<PersistImpl>) impl
{
    self = [super init];
    if (self) {
        _impl = [impl retain];
        [self load];
    }
    return self;
}

-(void)load
{
    NSDictionary* dict = [_impl loadAsDictionaryFromKey:SERVER_SETTING_KEY];
    NSDictionary* msgServer = [dict objectForKey:@"messagingServerModel"];
    if(msgServer)
    {
        self.messagingServerModel = [ServerModelBuilder buildFromDict:msgServer];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DDLogError(@"set value:%@ for undefined key:%@",[value description],key);
}

-(id)valueForUndefinedKey:(NSString *)key
{
    DDLogError(@"get value for undefined key:%@",key);
    return nil;
}

-(void)store
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(self.messagingServerModel)
    {
        [dic setObject:[ServerModelBuilder toDictionary:self.messagingServerModel] forKey:@"messagingServerModel"];
    }
    [_impl persistAllWithDictionary:dic toKey:SERVER_SETTING_KEY];
    [dic release];
}

-(void)clean
{
    self.messagingServerModel = nil;
    [_impl cleanForKey:SERVER_SETTING_KEY];
}

- (void)dealloc
{
    [_impl release];
    [_messagingServerModel release];
    
    [super dealloc];
}

@end
