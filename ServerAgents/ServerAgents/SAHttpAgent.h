//
//  BaseServerAgent.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAConstants.h"

typedef struct
{
    BOOL isFailed;
    SAFailReason failReason;
    NSInteger nativeCode;
} SAParseResult;

static inline SAParseResult* SAParseResultMake()
{
    SAParseResult *result = (SAParseResult*)malloc(sizeof(SAParseResult));
    result -> isFailed = NO;
    result -> failReason = 0;
    result -> nativeCode = 0;
    return result;
}

static inline SAParseResult* SAParseResultRelease(SAParseResult* result)
{
    if(result)
    {
        free(result);
    }
    return NULL;
}

static inline void SAParseResultSet(SAParseResult* result, BOOL isFailed,SAFailReason reason, NSInteger nativeCode)
{
    if(result)
    {
        result -> isFailed = isFailed;
        result -> failReason = reason;
        result -> nativeCode = nativeCode;
    }
}

static inline BOOL SAParseResultIsFailed(SAParseResult* result)
{
    if(!result)
    {
        return NO;
    }
    return result ->isFailed;
}

static inline SAFailReason SAParseResultFailReason(SAParseResult* result)
{
    if(!result)
    {
        return -1;
    }
    return result ->failReason;
}

static inline NSInteger SAParseResultNativeCode(SAParseResult* result)
{
    if(!result)
    {
        return -1;
    }
    return result ->nativeCode;
}


@interface SAHttpAgent : NSObject<ServerAgentProtocol, SAHttpHandlerDelegate>
{
    id<SADelegate> _delegate;
    
    NSString* _serviceType;
    
    NSInteger _totalBytes;
    
    NSInteger _readBytes;
    
    id<SAServiceLocator> _serviceLocator;
    
    SAParseResult* _parseResult;
}

@property(nonatomic,assign) NSInteger retryCount;

-(NSURL*) lookupUrlForServiceType:(NSString*) serviceType;

/**
 * subclass can use these two methods to send key-value pairs as request.
 */
-(void) requestWithService:(NSString *)serviceType andParameters:(NSArray*) reqParams;

-(void) requestWithService:(NSString *)serviceType parameters:(NSArray*) reqParams andTimeout:(NSInteger)timeout;

/**
 * subclass can use this to send a block of data as the request by post or get.
 */
-(id<SAHttpHandler>) requestWithService:(NSString*) serviceType headers:(NSDictionary*)headers  postOrGet:(BOOL)isPost data:(NSData*) postData andTimout:(NSInteger)timeout;

/**
 * subclass can use this to send a file as the request by post.
 */
-(id<SAHttpHandler>)requestWithService:(NSString *)serviceType headers:(NSDictionary *)headers filePath:(NSString*)filePath andTimout:(NSInteger)timeout;

/**
 * subclass can override this generate its own request format.
 */
-(NSData*) buildRequestFromParams:(NSArray*) reqParams;

-(void)addCommonParameters:(NSMutableArray*) array;

/**
 * subclass can override this to parse the response data.
 */
-(void) parseResponseData:(NSData*)data;
 
/**
 * If you don't change all http request handler, don't change this method
 * default implement. Subclass can override this to instantiate its own httphandler
 * type,otherwise use default.
 */
-(id<SAHttpHandler>) createHttpHandler;

/**
 * Set Delegate again,only used when the main request have done, we're trying to use it for another request.
 * if the agent can be reused, it will return YES,otherwise return NO.
 */
-(BOOL) reuseWithDelegate:(id<SADelegate>) delegate;

@end
