//
//  JSONServerAgent.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONHttpAgent.h"
#import "SAReqParameter.h"
NSInteger const SACommonBizCode = 0;

@implementation SAJSONHttpAgent


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
    NSString* syscodeStr = (NSString*)[dict objectForKey:kSASysCode];
    if(syscodeStr != nil)
    {
        _syscode = [syscodeStr intValue];
        NSInteger bizcode = [(NSString*)[dict objectForKey:kSABusinessCode] intValue];
        if(_syscode == eSASysOK)
        {
            [self parseBusinessObject:(NSDictionary*) [dict objectForKey:kSABusinessObject] code:bizcode andTimeStamp:[dict valueForKey:kSATimestamp]];
        }
        else {

            SAParseResultSet(_parseResult, YES, eSABusiness, _syscode);
            //[_delegate transactionFailedWithAgent:self reason:eSABusiness andNativeCode:_syscode];
        }
    }
    else {
        //This block is for old protocol complaint.
        [self parseBusinessObject:dict code:SACommonBizCode andTimeStamp:nil];
    }
    
}

-(void)markBusinessError:(NSInteger)bizCode
{
    SAParseResultSet(_parseResult, YES, eSABusiness, bizCode);
}

-(void)parseBusinessObject:(NSDictionary *)dict code:(NSInteger)bizcode andTimeStamp:(NSString *)timestamp
{
    @throw [NSException exceptionWithName:@"UnimplementedOperation" reason:@"This Operation should be implemented by subclasses" userInfo:nil];
}


-(NSData *)buildRequestFromParams:(NSArray *)reqParams
{
    if(reqParams == nil)
    {
        return nil;
    }
    NSMutableString* restfulParam = [[NSMutableString alloc]initWithCapacity:32];
    for(SAReqParameter* param in reqParams)
    {
        [restfulParam appendFormat:@"%@=%@&",param.key,[param.value description]];
    }
    if([restfulParam length] > 0)
    {
        [restfulParam deleteCharactersInRange:NSMakeRange([restfulParam length]-1, 1)];
    }
    NSData* data = [restfulParam dataUsingEncoding:NSUTF8StringEncoding];
    [restfulParam release];
    return data;
}

@end
