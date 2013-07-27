//
//  SAReqParameter.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAReqParameter : NSObject

@property(nonatomic,retain)  NSString* key;
@property(nonatomic,retain)  id<NSObject> value;

+reqParameterWithKey:(NSString*) key andValue:(id<NSObject>) value;
@end
