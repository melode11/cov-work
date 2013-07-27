//
//  Tool.m
//  AuroraPhone
//
//  Created by Kevin on 2/28/13.
//
//

#import "Tool.h"

@implementation Tool

+ (NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end

