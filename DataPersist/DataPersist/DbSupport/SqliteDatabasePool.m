//
//  SqliteDatabasePool.m
//  DataPersist
//
//  Created by Yao Melo on 8/8/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "SqliteDatabasePool.h"

SqliteDatabasePool* sharedInstance;

@implementation SqliteDatabasePool

+(SqliteDatabasePool *)sharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[SqliteDatabasePool alloc] init];
    }
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _table = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(SqliteDatabaseWrapper *)getDatabaseWithPath:(NSString *)fullPath
{
    id db = [_table objectForKey:fullPath];
    if(!db)
    {
        db = [[SqliteDatabaseWrapper alloc] initWithPath:fullPath];
        [_table setObject:db forKey:fullPath];
        [db release];
    }
    return db;
}

-(oneway void)release
{
    
}

-(id)autorelease
{
    return self;
}

-(id)retain
{
    return self;
}

+(id)alloc
{
    NSAssert(sharedInstance == nil, @"Trying to initiate more than one instance");
    return [super alloc];
}


@end
