//
//  LAStyleManager.m
//  AuroraPhone
//
//  Created by Melo Yao on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LAStyleManager.h"

@implementation LAStyleManager

static LAStyleManager* sharedInstance;

- (id) init
{
    self = [super init];
    return self;
}

+ (LAStyleManager*) sharedInstance
{
    
    if(sharedInstance == nil)
    {
        @synchronized([LAStyleManager class])
        {
            if(sharedInstance == nil)
            {
                LAStyleManager* manager = [[LAStyleManager alloc] init];
                sharedInstance = manager;
            }
        }
        
    }
    return sharedInstance;
}


-(UIColor *)getColorWithType:(AnnotationType)type isReceived:(BOOL) isRecv
{
    //Following condition equals to ((!isRecv && isP2PInitor) || (isRecv && !isP2PInitor))
    if(isRecv != _isInitator)
    {
        return [UIColor purpleColor];
    }
    else {
        return [UIColor orangeColor];
    }
}

-(void)setIsInitiator:(BOOL)isInitiator
{
    _isInitator = isInitiator;
}

@end
