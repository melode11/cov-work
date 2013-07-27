//
//  BaseDAO.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseDAO.h"

@implementation BaseDAO

-(void)store
{
    @throw [NSException exceptionWithName:@"UnimplementedOperation" reason:@"This Operation should be implemented by subclasses" userInfo:nil];
}

-(void)clean
{
    @throw [NSException exceptionWithName:@"UnimplementedOperation" reason:@"This Operation should be implemented by subclasses" userInfo:nil];
}

-(void)load
{
    @throw [NSException exceptionWithName:@"UnimplementedOperation" reason:@"This Operation should be implemented by subclasses" userInfo:nil];
}

@end
