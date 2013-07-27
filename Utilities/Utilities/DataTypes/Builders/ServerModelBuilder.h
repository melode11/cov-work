//
//  ServerModelBuilder.h
//  Utilities
//
//  Created by Yao Melo on 7/23/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerModel.h"
@interface ServerModelBuilder : NSObject

+(ServerModel*) buildFromDict:(NSDictionary*) dic;

+(NSDictionary*) toDictionary:(ServerModel*) profile;
@end
