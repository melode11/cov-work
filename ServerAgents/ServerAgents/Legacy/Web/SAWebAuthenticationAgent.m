//
//  SAWebAuthenticationAgent.m
//  AuroraPhone
//
//  Created by Melo Yao on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAWebAuthenticationAgent.h"
#import "HTTPHandler.h"
#import "Base64EncoderDecoder.h"
#import "HTTPSecureModel.h"


@implementation SAWebAuthenticationAgent

-(void)requestWebAuthenticateWithUsername: (NSString*) username password:(NSString*)password
{   
//    [NSDictionary dictionaryWithObjectsAndKeys:[self concatenateAuthenticationStringWithUsername:username password:password],@"Authorization",nil]
    _username = [username retain];
    _password = [password retain];
    [self requestWithService:SERVICE_WEBAUTHENTICATE headers:nil postOrGet:NO data:nil andTimout:SA_DEFAULT_TIMOUT];
}

-(void)parseResponseData:(NSData *)data
{
    //no data to parse
}

-(void)connectionWillSendAuthentication:(HTTPSecureModel *)secureModel
{
    secureModel.user = _username;
    secureModel.password = _password;
}

-(id<SAHttpHandler>) createHttpHandler
{
    return [[[HTTPHandler alloc] init] autorelease];
}

-(void)dealloc
{
    [_username release];
    [_password release];
    [super dealloc];
}

@end
