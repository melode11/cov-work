//
//  NSDate+relativeDateString.m
//  AuroraPhone
//
//  Created by Yao Melo on 11/21/12.
//
//

#import "NSDate+relativeDateString.h"

@implementation NSDate(RelativeDateString)

-(NSString *)relativeDateString {
    NSDate *callDate =self;
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSDate *lastMidnight = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
    
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    components.day = -1;
    NSDate *yesterdayMidnight = [calendar dateByAddingComponents:components toDate:lastMidnight options:0];
    
    NSString *dateStr = @"";
    if ([callDate timeIntervalSinceNow] > [lastMidnight timeIntervalSinceNow]) {
        NSDateFormatter *timeFormater = [[[ NSDateFormatter alloc] init]autorelease];
        [timeFormater setDateStyle:NSDateFormatterNoStyle];
        [timeFormater setTimeStyle:NSDateFormatterShortStyle];
        dateStr = [timeFormater stringFromDate:callDate];
    } else if ([callDate timeIntervalSinceNow] > [yesterdayMidnight timeIntervalSinceNow] ) {
        dateStr = @"Yesterday";
    } else {
        NSDateFormatter *dateFormater = [[[ NSDateFormatter alloc] init]autorelease];
        [dateFormater setDateStyle:NSDateFormatterShortStyle];
        [dateFormater setTimeStyle:NSDateFormatterNoStyle];
        dateStr = [dateFormater stringFromDate:callDate];
    }
    
    return dateStr;
}

@end
