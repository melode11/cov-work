//
//  NSString+CallRelativeDate.m
//  AuroraPhone
//
//  Created by Mick Lester on 11/8/12.
//
//

#import "NSString+CallRelativeDate.h"

@implementation NSString (CallRelativeDate)

// This method formats the date like the Recents on the iPhone call log.
-(NSString *)relativeDateString {

    NSDateFormatter *fullFormater = [[[ NSDateFormatter alloc] init]autorelease];
    [fullFormater setDateStyle:NSDateFormatterShortStyle];
    [fullFormater setTimeStyle:NSDateFormatterNoStyle];

    NSDate *callDate = [fullFormater dateFromString:self];

    // This needs to be removed as we will only have one date - format.
    if (callDate == nil) {
        [fullFormater setTimeStyle:NSDateFormatterShortStyle];
        callDate = [fullFormater dateFromString:self];
    }

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
