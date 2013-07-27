//
//  UserProfileBuilder.m
//  AuroraPhone
//
//  Created by Melo Yao on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserProfileBuilder.h"
#import "DTConstants.h"
#import "ProductGroupBuilder.h"
#import "NSDictionary+SafeAccess.h"

@implementation UserProfileBuilder

+(UserProfile *)buildFromDict:(NSDictionary *)dic
{
    UserProfile* profile = [[[UserProfile alloc]init]autorelease];
    profile.userId = [[dic objectForKeyNullToNil:kUserProfileId] integerValue];
    profile.name = [dic objectForKeyNullToNil:kUserProfileName];
    profile.displayName = [dic objectForKeyNullToNil:kUserProfileDisplayName];
    NSDictionary* groupDic = [dic objectForKeyNullToNil:kUserProfileProductGroup];
    if(groupDic)
    {
        profile.productGroup = [ProductGroupBuilder buildFromDict:groupDic];
    }
    return profile;
}

+(NSDictionary *)toDictionary:(UserProfile *)profile
{
    if(profile.productGroup)
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:profile.userId],kUserProfileId,profile.name,kUserProfileName,profile.displayName,kUserProfileDisplayName,[ProductGroupBuilder toDictionary:profile.productGroup],kUserProfileProductGroup, nil];
    }
    else {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:profile.userId],kUserProfileId, profile.name,kUserProfileName,profile.displayName,kUserProfileDisplayName, nil];

    }
}

@end
