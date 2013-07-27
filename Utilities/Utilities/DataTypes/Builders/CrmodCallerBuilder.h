//
//  CrmodCallerBuilder.h
//  Annotation_iPad
//
//  Created by WangMinqing on 1/29/13.
//
//

#import <Foundation/Foundation.h>
#import "CrmodCaller.h"

@interface CrmodCallerBuilder : NSObject
+(CrmodCaller*) buildFromDict:(NSDictionary*) dict;
+(NSDictionary*)toDictionary:(CrmodCaller*) contact;

@end
