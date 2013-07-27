//
//  Annotation.h
//  Annotation
//
//  Created by Yao Melo on 5/22/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LAAttribute <NSObject>

-(NSDictionary*)properties;

-(NSInteger)tag;

-(AnnotationType)annotationType;

@end