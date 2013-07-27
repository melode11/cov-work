//
//  UserProfileDAO.m
//  AuroraPhone
//
//  Created by Melo Yao on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserProfileDAO.h"
#import "Utilities/UserProfileBuilder.h"
#define USERPROFILE_FILE  @"userprofile"

@implementation UserProfileDAO


-(id)initWithImpl:(id<PersistImpl>) impl
{
    self = [super init];
    if(self)
    {
        _impl = [impl retain];
        [self load];
    }
    return self;
}

-(void)store
{
    if(_isDirty && self.userProfile)
    {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.isAuthenticated],@"isauthenticated",
                          [UserProfileBuilder toDictionary:self.userProfile],@"userprofile",_token,@"token", nil];
        [_impl persistAllWithDictionary:dic toKey:USERPROFILE_FILE];
    }
    _isDirty = NO;
}

-(void)clean
{
    self.isAuthenticated = NO;
    self.userProfile = nil;
    [_impl cleanForKey:USERPROFILE_FILE];
    _isDirty = NO;
}

-(void)load
{
    NSDictionary* dic = [_impl loadAsDictionaryFromKey:USERPROFILE_FILE];
    self.isAuthenticated = [[dic objectForKey:@"isauthenticated"] boolValue];
    self.userProfile = [UserProfileBuilder buildFromDict:[dic objectForKey:@"userprofile"]];
    self.token = [dic objectForKey:@"token"];
    _isDirty = NO;
}

-(void)dealloc
{
    [_impl release];
    self.userProfile = nil;
    [super dealloc];
}

-(void)setIsAuthenticated:(BOOL)isAuth
{
    _isDirty = YES;
    _isAuthenticated = isAuth;
}

-(void)setUserProfile:(UserProfile *)userPro
{
    if(_userProfile)
    {
        [_userProfile release];
    }
    _userProfile = [userPro retain];
    _isDirty = YES;

}

@end
