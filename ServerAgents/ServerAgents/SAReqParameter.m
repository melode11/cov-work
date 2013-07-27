//
//  SAReqParameter.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAReqParameter.h"

@implementation SAReqParameter

@synthesize key;
@synthesize value;

+(id)reqParameterWithKey:(NSString *)key andValue:(id<NSObject>)value
{
    SAReqParameter* param = [[SAReqParameter alloc]init];
    param.key = key;
    param.value = value;
    return [param autorelease];
}

@end
