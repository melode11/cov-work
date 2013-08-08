//
//  ParamsMessage.m
//  Messaging
//
//  Created by Yao Melo on 7/30/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "ParamsMessage.h"

@implementation ParamsMessage

-(id)initWithParams:(NSMutableDictionary *)dic andType:(NSString *)type
{
    self = [super init];
    if(self)
    {
        _params = dic;
        _type = type;
    }
    return self;
}

-(NSDictionary *)data
{
    [_params setObject:self.msgID forKey:@"id"];
    return _params;
}

@end
