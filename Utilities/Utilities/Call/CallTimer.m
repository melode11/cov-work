//
//  CallTimer.m
//  Annotation_iPad
//
//  Created by Kevin on 11/29/12.
//
//

#import "CallTimer.h"

#define minutes(seconds) round(seconds /60)
#define hours(seconds) round(seconds /60/60)

static NSDate* s_callStartTime = nil;

@implementation CallTimer

+(void)markCallStart
{
    if(s_callStartTime)
    {
        [s_callStartTime release];
    }
    s_callStartTime = [[NSDate alloc] init];
}

+(NSDate *)callStartTime
{
    return [[s_callStartTime retain] autorelease];
}

+(NSString *)humanReadableDuration
{
    return [self humanReadableDateStyle:s_callStartTime];
}

+ (NSString *)humanReadableDateStyle:(NSDate *)aDate
{
    NSTimeInterval interval = [aDate timeIntervalSinceNow];
    
    long long int ti = round(-interval);
    NSString *formatedDateStr = @"";
    
    if (ti < 0) {
        formatedDateStr = [NSString stringWithFormat:@"error"];
    } else {
        int seconds = ti;
        int minutes = 0;
        int hours = 0;
        
        formatedDateStr = [NSString stringWithFormat:@"00:%02d", seconds];
        
        if (seconds >= 60) {
            seconds = (ti % 60);
            minutes = minutes(ti);
            formatedDateStr = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        }
        
        if (minutes >= 60) {
            minutes = minutes(ti % (60*60));
            hours = hours(ti);
            formatedDateStr = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
        }
    }
    return formatedDateStr;
}

@end
