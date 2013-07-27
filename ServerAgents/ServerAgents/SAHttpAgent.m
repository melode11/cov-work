//
//  BaseServerAgent.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAHttpAgent.h"
#import "SAReqParameter.h"
#import "Utilities/DeviceProfile.h"
#import "ASIHttpHandler.h"
#import "HTTPHandler.h"

@implementation SAHttpAgent
@synthesize retryCount;


-(id)initWithDelegate:(id<SADelegate>)delegate andServiceLocator:(id<SAServiceLocator>)serviceLocator
{
    self = [super init];
    if(self !=nil)
    {
        _delegate = [delegate retain];
        _serviceType = nil;
        _readBytes = _totalBytes = 0;
        _serviceLocator = [serviceLocator retain];
        self.retryCount = 0;
    }
    return self;
}

-(NSInteger)readBytes
{
    return _readBytes;
}

-(NSInteger)totalBytes
{
    return _totalBytes;
}

-(NSString *)serviceType
{
    return [NSString stringWithString: _serviceType];
}

-(void)dealloc
{
    [_serviceType release];
    [_serviceLocator release];
    [_delegate release];
    [super dealloc];
}

-(NSURL *)lookupUrlForServiceType:(NSString *)serviceType
{
    return [NSURL URLWithString:[_serviceLocator lookupUrlForService:serviceType]];
}

-(void)connectionDidFail:(id<SAHttpHandler>)theConnection
{
    [_delegate transactionFailedWithAgent:self reason:eSANetwork andNativeCode:theConnection.errorCode];
    //release here to avoid circular reference.
    [_delegate release];
    _delegate = nil;
    DDLogWarn(@"Connection Failed in SAHttpAgent!");
}


-(void)connectionDidFinish:(id<SAHttpHandler>)theConnection
{
    if([_delegate respondsToSelector:@selector(updateProgressWithAgent:andStage:)])
    {
        [_delegate updateProgressWithAgent:self andStage:eSAParsing];
    }
    _parseResult = SAParseResultMake();
   
    @try {
        [self parseResponseData:[NSData dataWithData: theConnection.receivedData]];
        if(SAParseResultIsFailed(_parseResult))
        {
            [_delegate transactionFailedWithAgent:self reason:SAParseResultFailReason(_parseResult) andNativeCode:SAParseResultNativeCode(_parseResult)];
        }
        else {
            [_delegate transactionFinishedWithAgent:self];
        }
    }
    @catch (NSException *exception) {
        DDLogError(@"exception:%@",[exception reason]);
    }
    @finally {
        _parseResult = SAParseResultRelease(_parseResult);
    }
    //release here to avoid circular reference.
    [_delegate release];
    _delegate = nil;
}

-(void)connectionDidReceiveData:(id<SAHttpHandler>)theConnection
{
    _readBytes = [theConnection receivedBytes];
    _totalBytes = [theConnection expectBytes];
    if([_delegate respondsToSelector:@selector(updateProgressWithAgent:andStage:)])
    {
        [_delegate updateProgressWithAgent:self andStage:eSAReceiving];    
    }

}

-(void)requestWithService:(NSString *)serviceType andParameters:(NSArray *)reqParams
{
    [self requestWithService:serviceType parameters:reqParams andTimeout:SA_DEFAULT_TIMOUT];
}

-(void)requestWithService:(NSString *)serviceType parameters:(NSArray *)reqParams andTimeout:(NSInteger)timeout
{
    if([_delegate respondsToSelector:@selector(serverAgent:willRequest:)])
    {
        //assign service type earlier for this case.
        [_serviceType release];
        _serviceType = [serviceType retain];
        [_delegate serverAgent:self willRequest:reqParams];
    }
    [self requestWithService:serviceType headers:nil postOrGet:YES data:[self buildRequestFromParams:reqParams] andTimout:timeout];
}

-(id<SAHttpHandler>)requestWithService:(NSString *)serviceType headers:(NSDictionary *)headers postOrGet:(BOOL)isPost data:(NSData *)data andTimout:(NSInteger)timeout
{
    if(!_delegate)
    {
        @throw [NSException exceptionWithName:@"IllegalState" reason:@"No delegate,Do you trying to reusing this agent?" userInfo:nil];
    }
    [_serviceType release];
    _serviceType = [serviceType retain];
    id<SAHttpHandler> handler = [self createHttpHandler];
    handler.retryCount = self.retryCount;
    if(isPost)
    {
        [handler doPostWithDelegate:self request:headers postData:data url:[self lookupUrlForServiceType:serviceType] withTimeout:timeout];
    }
    else {
        [handler doGetWithDelegate:self request:headers url:[self lookupUrlForServiceType:serviceType] withTimeout:timeout];
    }
    if([_delegate respondsToSelector:@selector(updateProgressWithAgent:andStage:)])
    {
        [_delegate updateProgressWithAgent:self andStage:eSASending];
    }
    return handler;
}

-(id<SAHttpHandler>)requestWithService:(NSString *)serviceType headers:(NSDictionary *)headers filePath:(NSString*)filePath andTimout:(NSInteger)timeout
{
    if(!_delegate)
    {
        @throw [NSException exceptionWithName:@"IllegalState" reason:@"No delegate,Do you trying to reusing this agent?" userInfo:nil];
    }
    _serviceType = [serviceType retain];
    id<SAHttpHandler> handler = [self createHttpHandler];
    handler.retryCount = self.retryCount;
    [handler doPostWithDelegate:self request:headers filePath:filePath url:[self lookupUrlForServiceType:serviceType] withTimeout:timeout];
    if([_delegate respondsToSelector:@selector(updateProgressWithAgent:andStage:)])
    {
        [_delegate updateProgressWithAgent:self andStage:eSASending];
    }
    return handler;
}

-(void)parseResponseData:(NSData *)data
{
    @throw [NSException exceptionWithName:@"UnimplementedOperation" reason:@"This Operation should be implemented by subclasses" userInfo:nil];
}

-(NSData *)buildRequestFromParams:(NSArray *)reqParams
{
    @throw [NSException exceptionWithName:@"UnimplementedOperation" reason:@"This Operation should be implemented by subclasses" userInfo:nil];   
}

-(void)addCommonParameters:(NSMutableArray*) array
{
    DeviceProfile* profile = [DeviceProfile Instance];
    [array addObject:[SAReqParameter reqParameterWithKey:@"devicetype" andValue:profile.deviceName]];
}

-(id<SAHttpHandler>) createHttpHandler
{
    return [[[ASIHttpHandler alloc] init] autorelease];
}

-(BOOL)reuseWithDelegate:(id<SADelegate>)delegate
{
    [_delegate release];
    _delegate = [delegate retain];
    return YES;
}

@end
