//
//  ProductGroup.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProductGroup.h"

@implementation ProductGroup

@synthesize groupId;
@synthesize name;

-(void)dealloc
{
    self.name = nil;
    [super dealloc];
}

@end
