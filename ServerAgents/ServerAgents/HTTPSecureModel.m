//
//  HttpSecureModel.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HTTPSecureModel.h"

@implementation HTTPSecureModel

@synthesize user;
@synthesize password;

-(id)init
{
    self = [super init];
    if(self)
    {
        self.user = DEFUALT_SESSION_USER;
        self.password = DEFUALT_SESSION_PWD;
    }
    return self;
}



- (void)dealloc
{
    [user release];
    [password release];
    [super dealloc];
}

@end
