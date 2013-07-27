//
//  Sa2Profile.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Sa2ProfileBuilder.h"
#import "DTConstants.h"

@implementation Sa2ProfileBuilder

+(NSDictionary *)toDictionary:(Sa2Profile *)profile
{
    return [NSDictionary dictionaryWithObjectsAndKeys:profile.code,kSa2ProfileCode,profile.name,kSa2ProfileName, nil];
}

+(Sa2Profile *)buildFromDict:(NSDictionary *)dic
{
    Sa2Profile* prof = [[[Sa2Profile alloc]init]autorelease];
    prof.code = [[dic objectForKey:kSa2ProfileCode] description];
    prof.name = [dic objectForKey:kSa2ProfileName];
    return prof;
}

@end
