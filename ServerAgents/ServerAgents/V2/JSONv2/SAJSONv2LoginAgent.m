//
//  SAJSONv2LoginAgent.m
//  ServerAgents
//
//  Created by Yao Melo on 7/18/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "SAJSONv2LoginAgent.h"
#import "SAReqParameter.h"
#import "Utilities/DeviceProfile.h"
#import "Utilities/Tool.h"
#import "Utilities/NSString+MD5.h"
#import "Utilities/ServerModelBuilder.h"
@implementation SAJSONv2LoginAgent

-(void)requestLoginWithName:(NSString *)username password:(NSString *)psw
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSString* md5 = [psw md5Value];
    [array addObject:[SAReqParameter reqParameterWithKey:@"username" andValue:username]];
    [array addObject:[SAReqParameter reqParameterWithKey:@"password" andValue:md5]];
    [array addObject:[SAReqParameter reqParameterWithKey:@"device" andValue:[[[DeviceProfile Instance] deviceName] lowercaseString]]];
    [array addObject:[SAReqParameter reqParameterWithKey:@"version" andValue:[Tool getAppVersion]]];
    [self requestWithService:SERVICE_LOGIN andParameters:array];
    [array release];
    
}

-(void)parseBusinessObject:(NSDictionary *)dict
{
    self.token = [dict objectForKey:@"token"];
    NSDictionary *user = [dict objectForKey:@"user"];
    self.userName = [user objectForKey:@"username"];
    self.displayName = [user objectForKey:@"display_name"];
    self.messagingServer = [ServerModelBuilder buildFromDict:[[dict objectForKey:@"server"] objectForKey:@"messaging"]];
    self.userId = [[user objectForKey:@"id"] integerValue];
}

- (void)dealloc
{
    [_token release];
    [_userName release];
    [_messagingServer release];
    [_displayName release];
    [super dealloc];
}

@end
