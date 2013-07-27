//
//  PListPersistUtility.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PListPersistImpl.h"

@implementation PListPersistImpl

- (id)initWithPath:(NSString *)basePath
{
    self = [super init];
    if (self) {
        _basePath = [basePath retain];
    }
    return self;
}

-(NSArray *)loadAsArrayFromKey:(NSString *)key
{
    return [NSArray arrayWithContentsOfFile:[_basePath stringByAppendingFormat:@"/%@.plist",key]];
}

-(NSDictionary *)loadAsDictionaryFromKey:(NSString *)key
{
    return [NSDictionary dictionaryWithContentsOfFile:[_basePath stringByAppendingFormat:@"/%@.plist",key]];
}

-(void)persistAllWithArray:(NSArray *)array toKey:(NSString *)key
{
    [array writeToFile:[_basePath stringByAppendingFormat:@"/%@.plist",key] atomically:YES];
}

-(void)persistAllWithDictionary:(NSDictionary *)dict toKey:(NSString *)key
{
    [dict writeToFile:[_basePath stringByAppendingFormat:@"/%@.plist",key] atomically:YES];
}

-(void)cleanForKey:(NSString *)key
{
    NSError* error;
    BOOL isDone = NO;
    isDone = [[NSFileManager defaultManager] removeItemAtPath:[_basePath stringByAppendingFormat:@"/%@.plist",key] error:&error];
    if(!isDone)
    {
        DDLogError(@"clean failed:%@", [error description]);
    }
    
}

- (void)dealloc
{
    [_basePath release];
    [super dealloc];
}

@end
