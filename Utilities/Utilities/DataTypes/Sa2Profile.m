//
//  Sa2Profile.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Sa2Profile.h"

@implementation Sa2Profile
@synthesize code;
@synthesize name;

-(void)dealloc{
    self.code = nil;
    self.name = nil;
    [super dealloc];
}

@end
