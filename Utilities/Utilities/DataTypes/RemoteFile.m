//
//  RemoteFile.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RemoteFile.h"

@implementation RemoteFile
@synthesize fileId;
@synthesize name;
@synthesize remotePath;

-(void)dealloc
{
    [name release];
    [remotePath release];
    [super dealloc];
}

@end
