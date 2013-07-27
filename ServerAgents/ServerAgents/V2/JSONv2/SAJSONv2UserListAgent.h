//
//  SAJSONv2UserListAgent.h
//  ServerAgents
//
//  Created by Yao Melo on 7/24/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "SAJSONv2HttpAgent.h"
#import "SABizProtocols.h"

@interface SAJSONv2UserListAgent : SAJSONv2HttpAgent<SAUserListProtocol>
{
    NSArray* _contacts;
    
    NSDictionary* _statusMapping;
    
    NSDictionary* _activeDevicesMapping;
    
    unsigned long long _timestamp;
}


@end
