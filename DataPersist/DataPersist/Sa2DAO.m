//
//  Sa2DAO.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Sa2DAO.h"
#define kSa2Profiles @"Sa2Profiles"

@implementation Sa2DAO
@synthesize sa2Profiles = _sa2Profiles;

-(id)initWithImpl:(id<PersistImpl>) impl
{
    self = [super init];
    if(self)
    {
        _impl = [impl retain];
        _isDirty = NO;
        [self load];
    }
    return self;
}

-(void)load
{
    _sa2Profiles = [[_impl loadAsArrayFromKey:kSa2Profiles] retain];
    _isDirty = NO;
}

-(void)updateSa2Profiles:(NSArray*) sa2Profiles
{
    [_sa2Profiles release];
    _sa2Profiles = [sa2Profiles retain];
    _isDirty = YES;
}

-(void)store
{
    if(_isDirty)
    {
        [_impl persistAllWithArray:_sa2Profiles toKey:kSa2Profiles];
        _isDirty = NO;
    }
}

-(void)clean
{
    [_sa2Profiles release];
    _sa2Profiles = nil;
    [_impl cleanForKey:kSa2Profiles];
    _isDirty = NO;
}

- (void)dealloc
{
    [_sa2Profiles release];
    [_impl release];
    [super dealloc];
}

@end
