/*
 Copyright (c) 2007-2011, GlobalLogic Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list
 of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or other
 materials provided with the distribution.
 Neither the name of the GlobalLogic Inc. nor the names of its contributors may be
 used to endorse or promote products derived from this software without specific
 prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 OF THE POSSIBILITY OF SUCH DAMAGE."
 */

#import "HTTPHandler.h"
#import "Utilities/constants.h"
#import "HTTPSecureModel.h"

@interface HTTPHandler()

-(void)createConnection:(NSDictionary*)request URL:(NSURL *)theURL isPost:(BOOL)isPost postData:(NSData*)data withTimeOut:(NSInteger)timeOut ;
-(void)createConnection:(NSDictionary*)request URL:(NSURL *)theURL postStream:(NSInputStream*)stream contentLength:(NSInteger)length withTimeOut:(NSInteger)timeOut;
-(void)createHeader:(NSMutableURLRequest*)theRequest requestHeader:(NSDictionary*)request;

-(void)doAuthenticate:(NSURLAuthenticationChallenge *)challenge withSecureModel:(HTTPSecureModel*) secureModel;

@end

@implementation HTTPHandler

@synthesize responseHeaders;
@synthesize responserequestType;
@synthesize errorCode;
@synthesize expectBytes = _expectBytes;
@synthesize retryCount;

//+(HTTPHandler *)handlerWithGetRequest:(NSDictionary *)request url:(NSURL *)theURL timeout:(NSInteger)timeout andDelegate:(id<HTTPHandlerDelegate>)delegate
//{
//    HTTPHandler* handler = [[[HTTPHandler alloc]initWithDelegate:delegate] autorelease];
//    [handler doGetWithRequest:request url:theURL withTimeout:timeout];
//    return handler;
//}
//
//+(HTTPHandler *)handlerWithPostRequest:(NSDictionary *)request data:(NSData *)data url:(NSURL *)theURL timeout:(NSInteger)timeout andDelegate:(id<HTTPHandlerDelegate>)delegate
//{
//    HTTPHandler* handler = [[[HTTPHandler alloc]initWithDelegate:delegate] autorelease];
//    [handler doPostWithRequest:request postData:data url:theURL withTimeout:timeout];
//    return handler;
//}


-(void)doPostWithDelegate:(id<SAHttpHandlerDelegate>)inDelegate request:(NSDictionary *)request postData:(NSData *)data url:(NSURL *)theURL withTimeout:(NSInteger)timeout
{
    [delegate release];
    delegate = [inDelegate retain];
    [self createConnection:request URL:theURL isPost:YES postData:data withTimeOut:timeout];
}

-(void)doGetWithDelegate:(id<SAHttpHandlerDelegate>)inDelegate request:(NSDictionary *)request url:(NSURL *)theURL withTimeout:(NSInteger)timeout
{
    [delegate release];
    delegate = [inDelegate retain];
    [self createConnection:request URL:theURL isPost:NO postData:nil withTimeOut:timeout];
}

-(void)doPostWithDelegate:(id<SAHttpHandlerDelegate>)inDelegate request:(NSDictionary *)request filePath:(NSString *)filePath url:(NSURL *)theURL withTimeout:(NSInteger)timeout
{
    [delegate release];
     delegate = [inDelegate retain];
    [self createConnection:request URL:theURL postStream:[NSInputStream inputStreamWithFileAtPath:filePath] contentLength:[[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize] withTimeOut:timeout];
}


/**
 --------------------------------------------------------------------------
 Method Name: createConnectionForAuthentication.
 
 Return Type: void
 
 Description: This is a asynchronus method for sending the USER name and password along with
 other HTTP header for the Authentication of the User and Device,
 --------------------------------------------------------------------------
 */

-(void)createConnection:(NSDictionary*)request URL:(NSURL *)theURL isPost:(BOOL)isPost postData:(NSData*)data withTimeOut:(NSInteger)timeOut
{
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL
															  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
														  timeoutInterval:timeOut];
    if(request != nil)
    {
        [self createHeader:theRequest requestHeader:request];
    }
	
	if(isPost)
	{
		NSString *msgLength = [NSString stringWithFormat:@"%d", [data length]];		
		[theRequest setHTTPMethod:@"POST"];
		[theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
		[theRequest setHTTPBody:data];
        //DDLogInfo(@"This is post data %@",data);
        DDLogVerbose(@"This is post URL %@",theURL);
	}
	else
	{
		[theRequest setHTTPMethod:@"GET"];
	}
	
	
	
	if (![self connectWithRequest:theRequest startImmediately:YES]) 
	{
		/* inform the user that the connection failed */
		[delegate connectionDidFail:self];
        [delegate release];
        delegate = nil;
	}
	else 
	{
		_receivedData = [[NSMutableData alloc] init];
	}
    
    
}

-(void)createConnection:(NSDictionary*)request URL:(NSURL *)theURL postStream:(NSInputStream*)stream contentLength:(NSInteger)length withTimeOut:(NSInteger)timeOut
{
	[delegate retain];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL
															  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
														  timeoutInterval:timeOut];
    if(request != nil)
    {
        [self createHeader:theRequest requestHeader:request];
    }
	
	[theRequest setHTTPMethod:@"POST"];
    if(length>0)
    {
        NSString *msgLength = [NSString stringWithFormat:@"%d", length];		
		
		[theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        
    }
    [theRequest setHTTPBodyStream:stream];
    //DDLogInfo(@"This is post data %@",data);
    DDLogVerbose(@"This is post URL %@",theURL);
    
	
	if (![self connectWithRequest:theRequest startImmediately:YES])
	{
		/* inform the user that the connection failed */
		[delegate connectionDidFail:self];
        [delegate release];
        delegate = nil;
	}
	else 
	{
		_receivedData = [[NSMutableData alloc] init];
	}
    
    
}

-(void)createHeader:(NSMutableURLRequest*)theRequest requestHeader:(NSDictionary*)request
{
    if (request == nil) return;
    
	int count = [request count];
	id objects[count];
    id keys[count];
	
    [request getObjects:objects andKeys:keys];
	DDLogVerbose(@"createHeader RequestHeader = %@",theRequest);
    DDLogVerbose(@"createHeader request = %@",request);
    int i;
    for(i = 0; i < [request count]; i++)
	{
		[theRequest addValue:objects[i] forHTTPHeaderField:keys[i]];
		DDLogVerbose(@"%d = %@ ,  %@",i,objects[i],keys[i]);
	}
}


-(BOOL) connectWithRequest:(NSURLRequest*) request startImmediately:(BOOL)isStartImmediately
{
    errorCode = 0;
    _expectBytes = 0;
    _storedRequest = [request retain];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request 
                                     delegate:self 
                             startImmediately:isStartImmediately];
    [_connectionLock lock];
    _connection = conn;
    [_connectionLock unlock];
    return YES;
}

-(void) disconnect
{
    [_connectionLock lock];
    if(_connection)
    {
        [_connection cancel];
        [_connection release];
        _connection = nil;
    }
    [_connectionLock unlock];
}

- (void)dealloc
{	
	NSLog(@"Dealloc called for httphandler");
    [delegate release];
    [responseHeaders release];
    self.responserequestType = nil;
    [_storedRequest release];
	[_receivedData release];
    [_connectionLock release];
    [_connection release];
	[super dealloc];
}



#pragma mark NSURLConnection delegate methods

/**
 --------------------------------------------------------------------------
 Method Name: didReceiveResponse
 
 Return Type: id
 
 Description: This method is called when the server has determined that it has
 enough information to create the NSURLResponse. It can be called
 multiple times, for example in the case of a redirect, so each time
 we reset the data.
 
 --------------------------------------------------------------------------
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{	
	NSDictionary * responseDic = [(NSHTTPURLResponse*)response allHeaderFields];
	self.responserequestType = [responseDic objectForKey:@"Rt"];
    //	DDLogInfo(@"***********%@",self.responserequestType);
    //	DDLogInfo(@"%d, statusCode",[response statusCode]);
	DDLogVerbose(@"[response allHeaderFields] %@",responseDic);
    [_receivedData setLength:0];
    _expectBytes = [response expectedContentLength];
    [responseHeaders release];
    responseHeaders = [responseDic retain];
    if([delegate respondsToSelector:@selector(connectionDidReceiveData:)])
    {
        [delegate connectionDidReceiveData:self];
    }
}
/**
 --------------------------------------------------------------------------
 Method Name: didReceiveData
 
 Return Type: void
 
 Description:  Append the new data to the received data.
 
 --------------------------------------------------------------------------
 */


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /* Append the new data to the received data. */
    [_receivedData appendData:data];
    if([delegate respondsToSelector:@selector(connectionDidReceiveData:)])
    {
        [delegate connectionDidReceiveData:self];
    }
}

/**
 --------------------------------------------------------------------------
 Method Name: didFailWithError
 
 Return Type: void
 
 Description: If there is any error while connectiing to the server
 
 --------------------------------------------------------------------------
 */

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Show appropriate error message

    if(self.retryCount -- == 0)
    {
        DDLogError(@"error %@",[error userInfo]);
        errorCode = [error code];
        
        if([delegate respondsToSelector:@selector(connectionDidFail:)])
        {
            [delegate connectionDidFail:self];
        }
        [self releaseConnection];
        [delegate release];
        delegate = nil;
        //clear the cache memory 
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
        [NSURLCache setSharedURLCache:sharedCache];
        [sharedCache release];
    }
    else {
        if (![self connectWithRequest:_storedRequest startImmediately:YES])
        {
            /* inform the user that the connection failed */
            [delegate connectionDidFail:self];
            [delegate release];
            delegate = nil;
        }
        else 
        {
            [_receivedData release];
            _receivedData = [[NSMutableData alloc] init];
        }
    }
}



/**
 --------------------------------------------------------------------------
 Method Name: connectionDidFinishLoading
 
 Return Type: void
 
 Description: If connection finished successfuly.
 
 --------------------------------------------------------------------------
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

	//clear the cache memory 
	NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
	[NSURLCache setSharedURLCache:sharedCache];
	[sharedCache release];
	//DDLogInfo(@"connection.receivedData %@", self.receivedData);
	
	//[self.delegate connectionDidFinish:self];
    //better to check availablity of selector
	if ([delegate respondsToSelector:@selector(connectionDidFinish:)]) {
        [delegate performSelector:@selector(connectionDidFinish:) withObject:self];
    }
    [self releaseConnection];
    [delegate release];
    delegate = nil;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    HTTPSecureModel* secureModel = [[HTTPSecureModel alloc]init];
    NSLog(@"failed count:%d",[challenge previousFailureCount] );
    if([challenge previousFailureCount] > 0)
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        [secureModel release];
        return;
    }
    if([delegate respondsToSelector:@selector(connectionWillSendAuthentication:)])
    {
        [delegate connectionWillSendAuthentication:secureModel];
    }
    [self doAuthenticate:challenge withSecureModel:secureModel];
    [secureModel release];
}

-(void)doAuthenticate:(NSURLAuthenticationChallenge *)challenge withSecureModel:(HTTPSecureModel*) secureModel
{
    NSString *authMethod = [[challenge protectionSpace] authenticationMethod];
    if ([NSURLAuthenticationMethodServerTrust isEqualToString:authMethod]) {
        //[[challenge sender]
        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:[[challenge protectionSpace ]serverTrust]] forAuthenticationChallenge:challenge];
    }
    else if([NSURLAuthenticationMethodClientCertificate isEqualToString:authMethod])
    {
        
    }
    else
    {
        [[challenge sender] useCredential:[NSURLCredential credentialWithUser:secureModel.user password:secureModel.password persistence:NSURLCredentialPersistenceNone] forAuthenticationChallenge:challenge];
    }
}

-(NSData *)receivedData
{
    return _receivedData;
}

-(NSInteger)receivedBytes
{
    return [_receivedData length];
}

-(void)releaseConnection
{
    [_connectionLock lock];
    [_connection release];
    _connection = nil;
    [_connectionLock unlock];
}
@end
