//
//  ASIHttpHandler.m
//  AuroraPhone
//
//  Created by Yao Melo on 1/21/13.
//
//

#import "ASIHttpHandler.h"
#import "ASIHTTPRequest.h"
#import "HTTPSecureModel.h"

static inline void GracefullyPerformSelectorOnTarget(id target,SEL selector, id object)
{
    if([target respondsToSelector:selector])
    {
        [target performSelector:selector withObject:object];
    }
}

@interface ASIHttpHandler()
-(void)requestDidFinish:(ASIHTTPRequest*)request;
-(void)defaultConfigForRequest:(ASIHTTPRequest*)req;
- (void)handleAuthentication:(ASIHTTPRequest*)request;
@end

@implementation ASIHttpHandler

@synthesize responseHeaders;
@synthesize errorCode;
@synthesize retryCount;

-(id)init
{
    self = [super init];
    if(self)
    {
        _requestLock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

-(id)initWithQueue:(NSOperationQueue *)queue
{
    self = [self init];
    if(self)
    {
        _queue = [queue retain];
    }
    return self;
}

-(void)releaseConnection
{
    [_requestLock lock];
    [_requestRef release];
    _requestRef = nil;
    [_requestLock unlock];
    [_delegate release];
    _delegate = nil;
}

-(void)disconnect
{
    [_requestRef clearDelegatesAndCancel];
    [self releaseConnection];
}


-(void)doPostWithDelegate:(id<SAHttpHandlerDelegate>)inDelegate request:(NSDictionary *)request postData:(NSData *)data url:(NSURL *)theURL withTimeout:(NSInteger)timeout
{
    [_delegate release];
    _delegate = [inDelegate retain];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:theURL];
    //MELO:we are pretending to be a form for web services.
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
	[req addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@",charset]];
    for(NSString *key in [request keyEnumerator])
    {
        [req addRequestHeader:key value:[request objectForKey:key]];
    }
    [req setTimeOutSeconds:timeout];
    [req setRequestMethod:@"POST"];
    [req appendPostData:data];
    [self defaultConfigForRequest:req];
    [_requestLock lock];
    [_requestRef release];
    _requestRef = [req retain];
    [_requestLock unlock];
    if(_queue)
    {
        [_queue addOperation:req];
    }
    else
    {
        [req startAsynchronous];
    }
}

-(void)doGetWithDelegate:(id<SAHttpHandlerDelegate>)inDelegate request:(NSDictionary *)request url:(NSURL *)theURL withTimeout:(NSInteger) timeout
{
    [_delegate release];
    _delegate = [inDelegate retain];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:theURL];
    for(NSString *key in [request keyEnumerator])
    {
        [req addRequestHeader:key value:[request objectForKey:key]];
    }
    [req setTimeOutSeconds:timeout];
    [req setRequestMethod:@"GET"];
    [self defaultConfigForRequest:req];
    [_requestLock lock];
    [_requestRef release];
    _requestRef = [req retain];
    [_requestLock unlock];
    if(_queue)
    {
        [_queue addOperation:req];
    }
    else
    {
        [req startAsynchronous];
    }
}

-(void)doPostWithDelegate:(id<SAHttpHandlerDelegate>)inDelegate request:(NSDictionary *)request filePath:(NSString*)filePath url:(NSURL *)theURL withTimeout:(NSInteger) timeout
{
    [_delegate release];
    _delegate = [inDelegate retain];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:theURL];
    for(NSString *key in [request keyEnumerator])
    {
        [req addRequestHeader:key value:[request objectForKey:key]];
    }
    [req setTimeOutSeconds:timeout];
    [req setRequestMethod:@"POST"];
    [req setPostBodyFilePath:filePath];
    // AURORA-1749
    [req setShouldStreamPostDataFromDisk:YES];
    [self defaultConfigForRequest:req];
    [_requestLock lock];
    [_requestRef release];
    _requestRef = [req retain];
    [_requestLock unlock];
    if(_queue)
    {
        [_queue addOperation:req];
    }
    else
    {
        [req startAsynchronous];
    }
    
}

-(void)defaultConfigForRequest:(ASIHTTPRequest*)req
{
    [req setNumberOfTimesToRetryOnTimeout:self.retryCount];
    [req setDefaultResponseEncoding:NSUTF8StringEncoding];

    [req setValidatesSecureCertificate:NO];
    [req setDelegate:self];
    [req setDownloadProgressDelegate:self];
    [req setDidFinishSelector:@selector(requestDidFinish:)];
    [req setDidFailSelector:@selector(requestDidFailed:)];
    [req setDidReceiveResponseHeadersSelector:@selector(request:didReceiveResponse:)];
    //since the authentication selector is not explicitly declared, use block here.
    [req setAuthenticationNeededBlock:^(void){
        [self handleAuthentication:req];
    }];
    [req setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        GracefullyPerformSelectorOnTarget(_delegate,@selector(connectionDidReceiveData:),self);
    }];

}

-(void)request:(ASIHTTPRequest*)request didReceiveResponse:(NSMutableDictionary *)headers
{
    [responseHeaders release];
    responseHeaders = [[NSDictionary alloc]initWithDictionary:headers];
}

-(void)requestDidFinish:(ASIHTTPRequest *)request
{
    NSInteger statusCode = request.responseStatusCode;
    if(statusCode >= 400){
        //errorCode = [request.error code];
        errorCode = statusCode;
        GracefullyPerformSelectorOnTarget(_delegate,@selector(connectionDidFail:),self);
    } else {
        GracefullyPerformSelectorOnTarget(_delegate,@selector(connectionDidFinish:),self); 
    }
    [self releaseConnection];
}

-(void)requestDidFailed:(ASIHTTPRequest*)request
{
    errorCode = [request.error code];
    GracefullyPerformSelectorOnTarget(_delegate,@selector(connectionDidFail:),self);
    [self releaseConnection];
}

- (void)handleAuthentication:(ASIHTTPRequest*)request
{
    HTTPSecureModel *model = [[HTTPSecureModel alloc] init];
    GracefullyPerformSelectorOnTarget(_delegate,@selector(connectionWillSendAuthentication:),model);
    if(model.user && model.password)
    {
        [request setUsername:model.user];
        [request setPassword:model.password];
        [request retryUsingSuppliedCredentials];
    }
    else
    {
        [request cancelAuthentication];
    }
    [model release];
}

-(NSInteger)expectBytes
{
    return _requestRef.contentLength;
}

-(NSInteger)receivedBytes
{
    return _requestRef.totalBytesRead;
}

-(NSData *)receivedData
{
    return _requestRef.responseData;
}



- (void)dealloc
{
    [_queue release];
    [_requestRef release];
    [_delegate release];
    [responseHeaders release];
    [_requestLock release];
    [super dealloc];
}

@end
