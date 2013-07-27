//
//  AppVersionAgent.m
//  AuroraPhone
//
//  Created by Kevin on 2/28/13.
//
//

#import "SAJSONAppVersionAgent.h"
#import "SAReqParameter.h"

@implementation SAJSONAppVersionAgent

-(void)postAppVersion:(NSString *)versionNumber withLoginname:(NSString*) loginName
{
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:3];
    [params addObject:[SAReqParameter reqParameterWithKey:@"loginname" andValue:loginName]];
    [self addCommonParameters:params];
    [params addObject:[SAReqParameter reqParameterWithKey:@"version" andValue:versionNumber]];
    [self requestWithService:SERVICE_APPVERSION andParameters:params];
}

-(void)parseBusinessObject:(NSDictionary *)dict code:(NSInteger)bizcode andTimeStamp:(NSString *)timestamp
{
  
}

@end
