//
//  CompatibilityManager+Annotation.m
//  Annotation
//
//  Created by Yao Melo on 6/26/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "CompatibilityManager+Annotation.h"

@implementation CompatibilityManager (Annotation)

-(CGSize)targetVideoDimension
{
    return versionValue >= 2305?CGSizeMake(X_PIX_NORMALIZED, Y_PIX_NORMALIZED):CGSizeMake(X_PIX_NORMALIZED, 480);
}


@end
