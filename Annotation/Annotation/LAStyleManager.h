//
//  LAStyleManager.h
//  AuroraPhone
//
//  Created by Melo Yao on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAStyleManager : NSObject
{
    BOOL _isInitator;
}

-(UIColor *)getColorWithType:(AnnotationType)type isReceived:(BOOL) isRecv;

//Tell style manager if this is the call initiator.
-(void) setIsInitiator:(BOOL)isInitiator;

+ (LAStyleManager*) sharedInstance;

@end