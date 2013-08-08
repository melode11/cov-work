//
//  SAJSONv2UserListAgent.m
//  ServerAgents
//
//  Created by Yao Melo on 7/24/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "SAJSONv2UserListAgent.h"
#import "SAReqParameter.h"
#import "Utilities/ContactBuilder.h"

@implementation SAJSONv2UserListAgent

-(NSArray *)contacts
{
    return _contacts;
}

-(NSDictionary *)statusMapping
{
    return _statusMapping;
}

-(NSDictionary *)activeDevicesMapping
{
    return _activeDevicesMapping;
}

-(unsigned long long)timestamp
{
    return _timestamp;
}

-(void)requestUserListWithToken:(NSString *)loginToken
{
    NSArray* arr = [[NSArray alloc] initWithObjects:[SAReqParameter reqParameterWithKey:@"token" andValue:loginToken], nil];
    [self requestWithService:SERVICE_USERLIST andParameters:arr];
    [arr release];
}

-(void)parseBusinessObject:(NSDictionary *)dict
{
    _timestamp = [[dict objectForKey:@"ts"] longLongValue];
    NSArray* users = [dict objectForKey:@"users"];
    NSMutableArray *contacts = [[NSMutableArray alloc] initWithCapacity:[users count]];
    NSMutableDictionary *statusMapping = [[NSMutableDictionary alloc] initWithCapacity:[users count]];
    NSMutableDictionary *deviceMapping = [[NSMutableDictionary alloc] initWithCapacity:[users count]];
    for (NSDictionary* userDic in users) {
        Contact* contact = [ContactBuilder buildFromDict:userDic];
        [contacts addObject:contact];
        [statusMapping setObject:[NSNumber numberWithInteger:[[userDic objectForKey:@"status"] integerValue]] forKey:[NSNumber numberWithInteger:contact.contactId]];
        [deviceMapping setObject:[userDic objectForKey:@"device"] forKey:[NSNumber numberWithInteger:contact.contactId]];
    }
    [_contacts release];
    _contacts = contacts;
    [_statusMapping release];
    _statusMapping = statusMapping;
    [_activeDevicesMapping release];
    _activeDevicesMapping = deviceMapping;
}

- (void)dealloc
{
    [_contacts release];
    [_statusMapping release];
    [_activeDevicesMapping release];
    [super dealloc];
}


@end
