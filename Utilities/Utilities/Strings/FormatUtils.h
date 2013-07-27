//
//  FormatUtils.h
//  Annotation_iPad
//
//  Created by Yao Melo on 7/5/13.
//
//

#import <Foundation/Foundation.h>

@interface FormatUtils : NSObject

+(BOOL) validateEmail:(NSString*) email;

+(BOOL) validateUrl:(NSString*) url;

+(BOOL) validateIPv4Address:(NSString*) ip;

+(BOOL) validateIPv6Address:(NSString*) ip;

@end
