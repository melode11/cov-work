//
//  ServerModelBuilder.m
//  Utilities
//
//  Created by Yao Melo on 7/23/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "DTConstants.h"
#import "ServerModelBuilder.h"

@implementation ServerModelBuilder

+(ServerModel*) buildFromDict:(NSDictionary*) dic
{
    ServerModel *model = [[ServerModel alloc] init];
    for(NSString *key in [dic allKeys])
    {
        if([key hasSuffix:kServerModelHost])
        {
            model.host = [dic objectForKey:key];
        }
        else if([key hasSuffix:kServerModelPort])
        {
            model.port = [[dic objectForKey:key] integerValue];
        }
        else if([[key lowercaseString] hasSuffix:kServerModelProtocol])
        {
            model.protocol = [dic objectForKey:key];
        }
        else if([key hasSuffix:kServerModelPath])
        {
            model.path = [dic objectForKey:key];
        }
    }
    return [model autorelease];
}

+(NSDictionary*) toDictionary:(ServerModel*) profile
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString* keys[] = {kServerModelHost,kServerModelPort,kServerModelProtocol,kServerModelPath};
    for (int i = 0; i<4; ++i) {
        id obj = [profile valueForKey:keys[i]];
        if(obj)
        {
            [dic setObject:obj forKey:keys[i]];
        }
    }
    return [dic autorelease];
}

@end
