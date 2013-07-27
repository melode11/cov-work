//
//  ClientFeatureBuilder.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientFeatureBuilder.h"
#import "DTConstants.h"

@implementation ClientFeatureBuilder

+(NSDictionary *)toDictionary:(ClientFeature *)feature
{
    return [NSDictionary dictionaryWithObjectsAndKeys:feature.code,kClientFeatureCode,
            feature.name,kClientFeatureName,feature.description,kClientFeatureDescription,
            feature.version,kClientFeatureVersion,feature.parameters,kClientFeatureParameters
            ,nil];
}

+(ClientFeature *)buildFromDict:(NSDictionary *)dic
{
    ClientFeature* feature = [[[ClientFeature alloc]init]autorelease];
    feature.code = [dic objectForKey:kClientFeatureCode];
    feature.name = [dic objectForKey:kClientFeatureName];
    feature.description = [dic objectForKey:kClientFeatureDescription];
    feature.version = [dic objectForKey:kClientFeatureVersion];
    feature.parameters = [dic objectForKey:kClientFeatureParameters];
    return feature;
}

@end
