//
//  UserProfile.m
//  AuroraPhone
//
//  Created by Melo Yao on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile


- (void)dealloc
{
    [_name release];
    [_displayName release];
    [_productGroup release];
    [super dealloc];
}

@end
