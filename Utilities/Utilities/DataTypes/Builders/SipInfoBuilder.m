//
//  SipInfoBuilder.m
//  AuroraPhone
//
//  Created by Melo Yao on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SipInfoBuilder.h"
#import "DTConstants.h"

@implementation SipInfoBuilder

+(SipInfo *)buildFromDict:(NSDictionary *)dic
{
    SipInfo* si = [[[SipInfo alloc]init]autorelease];
    si.name = [dic objectForKey:kSipInfoName];
    si.supportType = [dic objectForKey:kSipInfoSupportType];
    NSDictionary* deviceType = [dic objectForKey:@"devicetype"];
    if(deviceType)
    {
        //for server data complaince.
        si.deviceName = [deviceType objectForKey:kSipInfoDeviceName];      
    }
    else {
        //for local DAO data
        si.deviceName = [dic objectForKey:kSipInfoDeviceName];
    }
    return si;
}

+(NSDictionary *)toDictionary:(SipInfo *)profile
{
    return [NSDictionary dictionaryWithObjectsAndKeys:profile.name,kSipInfoName,profile.supportType,kSipInfoSupportType,profile.deviceName,kSipInfoDeviceName, nil];
}

@end
