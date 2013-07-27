//
//  JSONServerAgent.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONv2HttpAgent.h"
#import "SAReqParameter.h"
#import <SBJson.h>
#import "Utilities/DeviceProfile.h"
#import "HTTPHandler.h"

@implementation SAJSONv2HttpAgent


-(void)parseResponseData:(NSData *)data
{
    [data retain];

    SBJsonStreamParserAdapter* adapter = [[SBJsonStreamParserAdapter alloc]init];
    adapter.delegate = self;
    SBJsonStreamParser* parser = [[SBJsonStreamParser alloc]init];
    parser.delegate = adapter;
    SBJsonStreamParserStatus status = SBJsonStreamParserComplete;
    @try {
        status = [parser parse:data];
    }
    @catch (NSException *exception) {
        DDLogError(@"parsing exeption:%@",exception.description);
        SAParseResultSet(_parseResult, YES, eSAException, 0);
        return;
//        [_delegate transactionFailedWithAgent:self reason:eSAException andNativeCode:0];
    }
    @finally {
        [data release];
        [adapter release];
        [parser release];
    }
    if(!SAParseResultIsFailed(_parseResult))
    {
        if(status != SBJsonStreamParserComplete)
        {
            SAParseResultSet(_parseResult, YES, eSAParse, status);
        }
    }
       
}


-(void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array
{
    //per transaction format,root object won't be array.
    SAParseResultSet(_parseResult, YES, eSABusiness, 0);
    
}

-(void)parser:(SBJsonStreamParser *)parser foundObject:(NSDictionary *)dict
{
    NSString* syscodeStr = (NSString*)[dict objectForKey:kSAResponseCode];
    if(syscodeStr != nil)
    {
        _respCode = [syscodeStr intValue];
        if(_respCode == 0)
        {
            [self parseBusinessObject:(NSDictionary*) [dict objectForKey:kSAResult]];
        }
        else {
            SAParseResultSet(_parseResult, YES, eSABusiness, _respCode);
            //[_delegate transactionFailedWithAgent:self reason:eSABusiness andNativeCode:_respCode];
        }
    }
    else
    {
        NSString* statusStr = (NSString*)[dict objectForKey:kSAResponseStatus];
        if(statusStr)
        {
            SAParseResultSet(_parseResult, YES, eSAException, [statusStr integerValue]);
        }
        else
        {
            //lost mandatory field, treat it as a parsing error.
            SAParseResultSet(_parseResult, YES, eSAParse, SBJsonStreamParserError);
        }
    }
}

-(id<SAHttpHandler>)requestWithService:(NSString *)serviceType headers:(NSDictionary *)headers filePath:(NSString *)filePath andTimout:(NSInteger)timeout
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:headers];
    [dic setObject: [NSString stringWithFormat:@"Helpsource %@ Client",[[DeviceProfile Instance]deviceName]] forKey:@"User-Agent"];
    return [super requestWithService:serviceType headers:dic filePath:filePath andTimout:timeout];
}

-(id<SAHttpHandler>)requestWithService:(NSString *)serviceType headers:(NSDictionary *)headers postOrGet:(BOOL)isPost data:(NSData *)postData andTimout:(NSInteger)timeout
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:headers];
    [dic setObject: [NSString stringWithFormat:@"Helpsource %@ Client",[[DeviceProfile Instance]deviceName]] forKey:@"User-Agent"];
    [dic setObject:@"application/json" forKey:@"Content-Type"];
    return [super requestWithService:serviceType headers:dic postOrGet:isPost data:postData andTimout:timeout];
}

-(void)markBusinessError:(NSInteger)bizCode
{
    SAParseResultSet(_parseResult, YES, eSABusiness, bizCode);
}

-(void)parseBusinessObject:(NSDictionary *)dict
{
    @throw [NSException exceptionWithName:@"UnimplementedOperation" reason:@"This Operation should be implemented by subclasses" userInfo:nil];
}


-(NSData *)buildRequestFromParams:(NSArray *)reqParams
{
    if(reqParams == nil)
    {
        return nil;
    }
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithCapacity:5];
    for(SAReqParameter* param in reqParams)
    {
        [mDic setObject:[param.value description] forKey:param.key];
    }
    
    SBJsonWriter* writer = [[SBJsonWriter alloc] init];
    NSData* data = [writer dataWithObject:mDic];
    [writer release];
    [mDic release];
    
    return data;
}


@end
