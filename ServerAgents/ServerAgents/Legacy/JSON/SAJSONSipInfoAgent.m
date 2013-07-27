//
//  SAJSONSipInfoAgent.m
//  AuroraPhone
//
//  Created by Melo Yao on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONSipInfoAgent.h"
#import "videoproxyModel.h"
#import "jabberprofileModel.h"
#import "SAReqParameter.h"
#import "SipInfoBuilder.h"

@implementation SAJSONSipInfoAgent
@synthesize videoproxyModel;
@synthesize jabberprofileModel;
@synthesize sipInfo;
@synthesize targetAppVersion;

-(void)requestSipInfo:(NSString *)sipId
{
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:3];
    [params addObject:[SAReqParameter reqParameterWithKey:@"sipid" andValue:sipId]];
    [self requestWithService:SERVICE_SIPINFO andParameters:params];
}

-(void)parseBusinessObject:(NSDictionary *)dict code:(NSInteger)bizcode andTimeStamp:(NSString *)timestamp
{
    self.videoproxyModel = [[[videoproxyModel alloc]init] autorelease];
    [self.videoproxyModel fromDict:[dict objectForKey:@"videoproxy"]];
    self.jabberprofileModel = [[[jabberprofileModel alloc]init]autorelease];
    [self.jabberprofileModel fromDict:[dict objectForKey:@"jabberprofile"]];
    self.sipInfo = [SipInfoBuilder buildFromDict:[dict objectForKey:@"info"]];
    self.targetAppVersion = [dict objectForKey:@"appversion"];
}


- (void)dealloc
{
    self.videoproxyModel = nil;
    self.jabberprofileModel = nil;
    [sipInfo release];
    [targetAppVersion release];
    [super dealloc];
}


@end
