//
//  SAWebAuthenticationAgent.h
//  AuroraPhone
//
//  Created by Melo Yao on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAHttpAgent.h"
#import "SABizProtocols.h"

@interface SAWebAuthenticationAgent : SAHttpAgent<SAWebAuthenticateProtocol>
{
    NSString* _username;
    NSString* _password;
}
@end
