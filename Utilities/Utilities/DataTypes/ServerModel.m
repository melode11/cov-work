//
//  ServerModel.m
//  Utilities
//
//  Created by Yao Melo on 7/23/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "ServerModel.h"

@implementation ServerModel

- (id)valueForUndefinedKey:(NSString *)key
{
    DDLogVerbose(@"The key %@ has no value assigned", key);
    return @"UnDefined";
}

- (void)dealloc
{
    [_host release];
    [_protocol release];
    [_path release];
    [super dealloc];
}

@end
