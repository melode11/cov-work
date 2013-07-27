//
//  ClientFeatureDAO.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientFeatureDAO.h"
#import "Utilities/ClientFeatureBuilder.h"

#define CLIENTFEATURE_FILE @"clientfeature"

@implementation ClientFeatureDAO

-(id)initWithImpl:(id<PersistImpl>)impl
{
    self = [super init];
    if(self)
    {
        _impl = [impl retain];
        [self load];
    }
    return self;
}

-(ClientFeature *)featureForCode:(NSString *)code
{
    if(_features!=nil)
    {
        for(ClientFeature* feature in _features)
        {
            if([feature.code isEqualToString:code])
            {
                return feature;
            }
        }
    }
    return nil;
}

-(NSArray *)AllFeatures{
    return _features;
}

-(void)updateFeatures:(NSArray *)features
{
    [_features release];
    _features = [[NSArray alloc]initWithArray:features];
}

-(void)clean
{
    [_impl cleanForKey:CLIENTFEATURE_FILE];
}

-(void)store
{
    NSMutableArray* storeArray = [NSMutableArray arrayWithCapacity:[_features count]];
    for(ClientFeature* feature in _features)
    {
        [storeArray addObject:[ClientFeatureBuilder toDictionary:feature]];
    }
    [_impl persistAllWithArray:storeArray toKey:CLIENTFEATURE_FILE];
}

-(void)load
{
    NSArray* storeArray = [_impl loadAsArrayFromKey:CLIENTFEATURE_FILE];
    NSMutableArray* loadArray = [NSMutableArray arrayWithCapacity:[storeArray count]];
    for(NSDictionary* dic in storeArray)
    {
        [loadArray addObject:[ClientFeatureBuilder buildFromDict:dic]];
    }
    _features = [[NSArray alloc] initWithArray:loadArray];
}

-(void)dealloc
{
    [_impl release];
    [_features release];
    [super dealloc];
}

@end
