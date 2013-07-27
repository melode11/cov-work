//
//  SAJSONProductGroupAgent.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONProductGroupAgent.h"
#import "ProductGroupBuilder.h"

@implementation SAJSONProductGroupAgent


-(void)requestGroups
{
    [self requestWithService:SERVICE_PRODUCTGROUP andParameters:nil];
}

-(NSArray *)getGroups
{
    return _groups;
}

-(void)parseBusinessObject:(NSDictionary *)dict code:(NSInteger)bizcode andTimeStamp:(NSString *)timestamp
{
    NSArray* groupArray = [dict objectForKey:@"productgroups"];
    NSInteger count = [groupArray count];
    if(count > 0)
    {
        NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:count];
        for(NSDictionary* dic in groupArray)
        {
            [array addObject: [ProductGroupBuilder buildFromDict:dic]];
        }
        _groups = [[NSArray alloc]initWithArray:array];
        [array release];
    }
    else {
        [self markBusinessError:bizcode];
    }
}


-(void)dealloc
{
    [_groups release];
    [super dealloc];
}

@end
