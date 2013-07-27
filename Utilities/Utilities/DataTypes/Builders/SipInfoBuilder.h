//
//  SipInfoBuilder.h
//  AuroraPhone
//
//  Created by Melo Yao on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SipInfo.h"

@interface SipInfoBuilder : NSObject

+(SipInfo*) buildFromDict:(NSDictionary*) dic;

+(NSDictionary*) toDictionary:(SipInfo*) profile;

@end
