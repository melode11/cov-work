//
//  ProductGroupBuilder.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProductGroupBuilder.h"
#import "DTConstants.h"

@implementation ProductGroupBuilder

+(ProductGroup *)buildFromDict:(NSDictionary *)dic
{
    ProductGroup* group = [[[ProductGroup alloc]init]autorelease];
    group.groupId = [(NSString*)[dic objectForKey:kProductGroupId] intValue];
    group.name = [dic objectForKey:kProductGroupName];
    return group;
}

+(NSDictionary *)toDictionary:(ProductGroup *)group
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",group.groupId],kProductGroupId,group.name,kProductGroupName, nil];
}

@end
