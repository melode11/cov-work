//
//  SAJSONSecureModelAgent.m
//  Annotation_iPad
//
//  Created by Yao Melo on 4/17/13.
//
//

#import "SAJSONSecureModelAgent.h"
#import "DeviceProfile.h"
#import "SAReqParameter.h"
#import <SBJson.h>
#import "SAEncryptUtil.h"
#import "Base64EncoderDecoder.h"

@implementation SAJSONSecureModelAgent
@synthesize secureType = _secureType;
@synthesize secureEncryptKey = _secureEncryptKey;
@synthesize secureToken = _secureToken;
@synthesize secureAllowFallback = _secureAllowFallback;

-(void)requestSecureModelWithName:(NSString *)loginName version:(NSString *)appVersion
{
    [_loginName release];
    _loginName = [loginName retain];
    [_appVersion release];
    _appVersion = [appVersion retain];
    [_deviceType release];
    _deviceType = [[[DeviceProfile Instance] deviceName] retain];
    NSArray* params = @[
                        [SAReqParameter reqParameterWithKey:@"loginname" andValue:loginName],
                        [SAReqParameter reqParameterWithKey:@"devicetype" andValue:_deviceType],
                        [SAReqParameter reqParameterWithKey:@"appversion" andValue:appVersion],
                        ];
    [self requestWithService:SERVICE_SECUREMODEL andParameters:params];
}

-(void)parseBusinessObject:(NSDictionary *)dict code:(NSInteger)bizcode andTimeStamp:(NSString *)timestamp
{
    if(bizcode != SACommonBizCode)
    {
        [self markBusinessError:bizcode];
        return;
    }
    _secureType = [[dict objectForKey:@"securetype"] integerValue];
    if(_secureType != eSecureNone)
    {
        [_secureEncryptKey release];
        _secureEncryptKey = [[dict objectForKey:@"key"] retain];
        id timeobj = [dict objectForKey:@"timestamp"];
        _secureKeyTimeMillis = [timeobj longLongValue];
        _secureAllowFallback = [[dict objectForKey:@"allowfallback"] boolValue];
        [_secureToken release];
        _secureToken = [[SAEncryptUtil tokenWithSecureType:_secureType secureKey:_secureEncryptKey name:_loginName time:timeobj deviceType:_deviceType version:_appVersion] retain];

    }
}

-(NSTimeInterval)secureKeyTime
{
    return (NSTimeInterval)_secureKeyTimeMillis / 1000.0;
}

- (void)dealloc
{
    [_secureEncryptKey release];
    [_secureToken release];
    [super dealloc];
}

@end
