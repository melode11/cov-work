//
//  ProductGroupBuilder.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductGroup.h"

@interface ProductGroupBuilder : NSObject

+(ProductGroup*) buildFromDict:(NSDictionary*) dic;

+(NSDictionary*) toDictionary:(ProductGroup*) group;

@end
