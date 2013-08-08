//
//  ChatContentBuilder.h
//  Utilities
//
//  Created by Yao Melo on 7/30/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatContent.h"
@interface ChatContentBuilder : NSObject
+(ChatContent*)buildFromDict:(NSDictionary*)dict;

+(NSDictionary*)toDictionary:(ChatContent*)cc;

@end
