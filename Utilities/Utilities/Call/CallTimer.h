//
//  CallTimer.h
//  Annotation_iPad
//
//  Created by Kevin on 11/29/12.
//
//

#import <Foundation/Foundation.h>


@interface CallTimer : NSObject

+ (void) markCallStart;

+ (NSString*)humanReadableDuration;

+ (NSDate*) callStartTime;

+ (NSString *)humanReadableDateStyle:(NSDate *)aDate;

@end
