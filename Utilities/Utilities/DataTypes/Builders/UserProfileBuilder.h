//
//  UserProfileBuilder.h
//  AuroraPhone
//
//  Created by Melo Yao on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"

@interface UserProfileBuilder : NSObject

+(UserProfile*) buildFromDict:(NSDictionary*) dic;

+(NSDictionary*) toDictionary:(UserProfile*) profile;


@end
