//
//  Sa2Profile.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sa2Profile.h"

@interface Sa2ProfileBuilder : NSObject

+(Sa2Profile*) buildFromDict:(NSDictionary*) dic;

+(NSDictionary*) toDictionary:(Sa2Profile*) profile;

@end
