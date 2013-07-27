//
//  NSDictionary+SafeAccess.m
//  AuroraPhone
//
//  Created by Yao Melo on 3/7/13.
//
//

#import "NSDictionary+SafeAccess.h"

@implementation NSDictionary (SafeAccess)

-(id)nulltoNilObjectForKey:(id)key
{
    id obj = [self objectForKey:key];
    if([obj isEqual:[NSNull null]])
    {
        return nil;
    }
    return obj;
}

-(id)objectForKeyFailedOnNull:(id)key
{
    id obj = [self objectForKey:key];
    if([obj isEqual:[NSNull null]])
    {
        [NSException raise:@"NullPointerException" format:@"Access to a null value with key:%@",[key description]];
    }
    return obj;
}

-(id)objectForKeyNullToNil:(id)key
{
    id obj = [self objectForKey:key];
    if([obj isEqual:[NSNull null]])
    {
        return nil;
    }
    return obj;
}

@end
