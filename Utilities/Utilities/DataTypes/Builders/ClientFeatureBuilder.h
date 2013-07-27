//
//  ClientFeatureBuilder.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientFeature.h"

@interface ClientFeatureBuilder : NSObject

+(ClientFeature*) buildFromDict:(NSDictionary*) dic;

+(NSDictionary*) toDictionary:(ClientFeature*) group;

@end
