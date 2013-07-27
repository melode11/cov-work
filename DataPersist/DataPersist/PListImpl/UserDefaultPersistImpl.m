//
//  UserDefaultPersistImpl.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-9-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserDefaultPersistImpl.h"

@implementation UserDefaultPersistImpl

-(void)persistAllWithArray:(NSArray *)array toKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)persistAllWithDictionary:(NSDictionary *)dict toKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(NSDictionary *)loadAsDictionaryFromKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
}

-(NSArray *)loadAsArrayFromKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}

-(void)cleanForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
