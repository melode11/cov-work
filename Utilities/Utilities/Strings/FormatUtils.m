//
//  FormatUtils.m
//  Annotation_iPad
//
//  Created by Yao Melo on 7/5/13.
//
//

#import "FormatUtils.h"

@implementation FormatUtils


+(BOOL)validateEmail:(NSString *)email
{
    if([email length] == 0)
    {
        return NO;
    }
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"^[\\d\\w\\.]+@([\\d\\w]+\\.{1})+[\\d\\w]+$" options:0 error:nil];
    NSRange rag = [regex rangeOfFirstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
    return (rag.location == 0 && rag.length == email.length);
}

+(BOOL)validateIPv4Address:(NSString *)ip
{
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" options:0 error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:ip options:0 range:NSMakeRange(0, [ip length])];
    return (range.location == 0 && range.length == ip.length);
}

+(BOOL)validateIPv6Address:(NSString *)ip
{
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"((([0-9A-Fa-f]{1,4}:){7}(([0-9A-Fa-f]{1,4})|:))|(([0-9A-Fa-f]{1,4}:){6}(:|((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})|(:[0-9A-Fa-f]{1,4})))|(([0-9A-Fa-f]{1,4}:){5}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){4}(:[0-9A-Fa-f]{1,4}){0,1}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){3}(:[0-9A-Fa-f]{1,4}){0,2}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){2}(:[0-9A-Fa-f]{1,4}){0,3}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:)(:[0-9A-Fa-f]{1,4}){0,4}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(:(:[0-9A-Fa-f]{1,4}){0,5}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})))" options:0 error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:ip options:0 range:NSMakeRange(0, [ip length])];
    return (range.location == 0 && range.length == ip.length);
}

+(BOOL)validateUrl:(NSString *)url
{
    return [NSURL URLWithString:url] != nil;
}

@end
