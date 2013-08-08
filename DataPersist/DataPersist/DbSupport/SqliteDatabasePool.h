//
//  SqliteDatabasePool.h
//  DataPersist
//
//  Created by Yao Melo on 8/8/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteDatabaseWrapper.h"
/**
 * !!! Not a threadsafe class
 */
@interface SqliteDatabasePool : NSObject
{
    NSMutableDictionary *_table;
    
    NSLock *_lock;
}

+(SqliteDatabasePool*) sharedInstance;

-(SqliteDatabaseWrapper*) getDatabaseWithPath:(NSString*)fullPath;

@end
