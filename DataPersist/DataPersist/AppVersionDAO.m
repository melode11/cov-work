//
//  AppVersionDAO.m
//  AuroraPhone
//
//  Created by Kevin on 3/1/13.
//
//

#import "AppVersionDAO.h"
#define APP_VERSION_KEY @"appversion"

@implementation AppVersionDAO
@synthesize versionNmuber;

- (id)initWithImpl:(id<PersistImpl>)impl
{
    self = [super init];
    if(self){
        _impl = [impl retain];
        [self load];
    }
    return self;
}

- (void)load
{
    NSDictionary *dic = [_impl loadAsDictionaryFromKey:APP_VERSION_KEY];
    if(dic){
        self.versionNmuber = [dic objectForKey:APP_VERSION_KEY];
    }
}

- (void)store
{
    //NSArray *arr =[NSArray arrayWithObject:versionNmuber];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:versionNmuber forKey:APP_VERSION_KEY];
    [_impl persistAllWithDictionary:dic toKey:APP_VERSION_KEY];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DDLogError(@"set value:%@ for undefined key:%@",[value description],key);
}

-(id)valueForUndefinedKey:(NSString *)key
{
    DDLogError(@"get value for undefined key:%@",key);
    return nil;
}

- (void)clean
{
    self.versionNmuber = nil;
    [_impl cleanForKey:APP_VERSION_KEY];
}

- (void)dealloc
{
    [_impl release];
    [versionNmuber release];
    [super dealloc];
}

@end
