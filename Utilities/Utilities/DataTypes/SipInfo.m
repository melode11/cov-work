//
//  SipInfo.m
//  AuroraPhone
//
//  Created by Melo Yao on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SipInfo.h"

@implementation SipInfo
@synthesize supportType;
@synthesize name;
@synthesize deviceName;

- (void)dealloc
{
    [supportType release];
    [name release];
    [deviceName release];
    [super dealloc];
}

@end
