//
//  UserProfileDAO.h
//  AuroraPhone
//
//  Created by Melo Yao on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseDAO.h"
#import "PersistImpl.h"

@class UserProfile;
@interface UserProfileDAO : BaseDAO
{
    id<PersistImpl> _impl;
    BOOL _isDirty;
}

@property(nonatomic,assign) BOOL isAuthenticated;

@property(nonatomic,retain) UserProfile* userProfile;

@property(nonatomic,retain) NSString* token;

-(id)initWithImpl:(id<PersistImpl>) impl;


@end
