//
//  SAJSONUserInfoAgent.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONUserInfoAgent.h"
#import "SAReqParameter.h"
#import "ClientFeatureBuilder.h"
#import "Sa2ProfileBuilder.h"
#import "constants.h"
#import "UserProfileBuilder.h"

@implementation SAJSONUserInfoAgent

@synthesize videoproxyModel;
@synthesize jabberprofileModel;
@synthesize sipprofileModel;
@synthesize supportsipprofilesModelArray;
@synthesize fileserverModel;
@synthesize userProfile;

-(void)requestUserInfo:(NSString *)loginName group:(NSString *)groupId
{
    NSMutableArray* params = [NSMutableArray arrayWithCapacity:4];
    [params addObject:[SAReqParameter reqParameterWithKey:@"loginname" andValue:loginName]];
    [params addObject:[SAReqParameter reqParameterWithKey:@"applygroupid" andValue:groupId]];
    [self addCommonParameters:params];
    [self requestWithService:SERVICE_USERINFO parameters:params andTimeout:30];
}

-(void)requestUserInfo:(NSString *)loginName group:(NSString *)groupId version:(NSString*) appVersion versionChanged:(BOOL)isChanged
{
    NSMutableArray* params = [NSMutableArray arrayWithCapacity:4];
    [params addObject:[SAReqParameter reqParameterWithKey:@"loginname" andValue:loginName]];
    [params addObject:[SAReqParameter reqParameterWithKey:@"applygroupid" andValue:groupId]];
    [params addObject:[SAReqParameter reqParameterWithKey:@"appversion" andValue:appVersion]];
    [params addObject:[SAReqParameter reqParameterWithKey:@"versionchanged" andValue:isChanged? @"1":@"0"]];
    [self addCommonParameters:params];
    [self requestWithService:SERVICE_USERINFO parameters:params andTimeout:30];
}

-(void)requestExtraInfo:(NSString *)loginName
{
    NSMutableArray* params = [NSMutableArray arrayWithCapacity:3];
    [params addObject:[SAReqParameter reqParameterWithKey:@"loginname" andValue:loginName]];
    [self addCommonParameters:params];
    [self requestWithService:SERVICE_EXTRAINFO parameters:params andTimeout:30];
}

-(NSArray *)features
{
    return _features;
}

-(NSArray *)sa2Profiles
{
    return _sa2Profiles;
}

-(void)parseBusinessObject:(NSDictionary *)dict code:(NSInteger)bizcode andTimeStamp:(NSString *)timestamp
{
    if(bizcode != SACommonBizCode)
    {
        [self markBusinessError:bizcode];
        return;
    }
    if([_serviceType isEqualToString:SERVICE_EXTRAINFO])
    {
        NSArray* features = [dict objectForKey:@"clientfeatures"];
        if([features count] >0)
        {
            NSMutableArray* tempArr = [NSMutableArray arrayWithCapacity:[features count]];
            for(NSDictionary* dic in features)
            {
                [tempArr addObject:[ClientFeatureBuilder buildFromDict:dic]];
            }
            _features = [[NSArray alloc]initWithArray:tempArr];
        }
        NSArray* sa2profs = [dict objectForKey:@"sa2"];
        if([sa2profs count]>0)
        {
            NSMutableArray* tempArr = [NSMutableArray arrayWithCapacity:[sa2profs count]];
            for(NSDictionary* dic in sa2profs)
            {
                [tempArr addObject:[Sa2ProfileBuilder buildFromDict:dic]];
            }
            _sa2Profiles = [[NSArray alloc]initWithArray:tempArr];
        }
    }
    else if([_serviceType isEqualToString:SERVICE_USERINFO]){
        for(NSString* key in [dict keyEnumerator])
        {
            NSString* className = [NSString stringWithFormat:@"%@Model",key];
            id obj = [dict objectForKey:key];
            if([className isEqualToString:kuinfoModel])
            {
                self.userProfile = [UserProfileBuilder buildFromDict:obj];
                continue;
            }
            Class clz = NSClassFromString(className);
            if(clz)
            {
                if([obj isKindOfClass:[NSArray class]])
                {
                    NSMutableArray* modelArray = [NSMutableArray arrayWithCapacity:2];
                    NSArray* arr = (NSArray*)obj;
                    for(NSDictionary* dic in arr)
                    {
                        id<NSObject> model = [[[clz alloc]init] autorelease];
                        if([model respondsToSelector:@selector(fromDict:)])
                        {
                            [model performSelector:@selector(fromDict:) withObject:dic];
                            [modelArray addObject:model];
                        }
                    }
                    [self setValue:modelArray forKey:[NSString stringWithFormat:@"%@Array",className]];
                }
                else {
                    id<NSObject> model = [[[NSClassFromString(className) alloc]init] autorelease];
                    if([model respondsToSelector:@selector(fromDict:)])
                    {
                        [model performSelector:@selector(fromDict:) withObject:obj];
                        [self setValue:model forKey:className];
                    }
                }
            }
            
        }        
//        self.videoproxyModel = [[[videoproxyModel alloc]init] autorelease];
//        [self.videoproxyModel fromDict:[dict objectForKey:kvideoproxyModel]];
//        self.fileserverModel = [[[fileserverModel alloc] init] autorelease];
//        [self.fileserverModel fromDict:[dict objectForKey:kfileserverModel]];
//        [self.sipprofileModel fromDict:[dict objectForKey:ksipprofileModel]];
//        [self.supportsipprofilesModel fromDict:[dict objectForKey:ksupportsipprofilesModel]];
//        [self.jabberprofileModel fromDict:[dict objectForKey:kjabberprofileModel]];
//
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DDLogError(@"set undefined key:%@ with value:%@",key,[value description]);
}

-(void)dealloc
{
    [_features release];
    [_sa2Profiles release];
    [userProfile release];
    self.videoproxyModel = nil;
    self.jabberprofileModel = nil;
    self.sipprofileModel = nil;
    self.supportsipprofilesModelArray = nil;
    self.fileserverModel = nil;
    [super dealloc];
}

@end
