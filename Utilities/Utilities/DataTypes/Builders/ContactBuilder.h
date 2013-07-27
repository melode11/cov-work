//
//  ContactBuilder.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"


@interface ContactBuilder : NSObject

+(Contact*) buildFromDict:(NSDictionary*) dict;
+(NSDictionary*)toDictionary:(Contact*) contact;

@end
