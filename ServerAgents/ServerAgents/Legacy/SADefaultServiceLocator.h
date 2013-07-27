//
//  SADefaultServiceLocator.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAConstants.h"

@interface SADefaultServiceLocator : NSObject<SAServiceLocator>

@property (nonatomic,retain) NSString* baseUrl;

+(SADefaultServiceLocator*) sharedInstance;

@end
