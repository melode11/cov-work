//
//  SAConstants.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef Annotation_iPad_SAConstants_h
#define Annotation_iPad_SAConstants_h
#import <Foundation/Foundation.h>
#import "Utilities/DTConstants.h"

#define SA_DEFAULT_TIMOUT 180


typedef enum {
    eSAParse,
    eSANetwork,
    eSAException,
    eSABusiness,
    eSABroadcast,/*The broadcast is used for driving delegate to do some further steps to finish the request.*/
    eSAUnknow
} SAFailReason;

typedef enum {
    eSASending,
    eSAReceiving,
    eSAParsing
} SAStage;

typedef SecureType SASecureType;


typedef enum
{
    eSASysOK = 0,
    
    eSASysSecureErrMin = 10,
    eSASysEncError = 10,
    eSASysBadToken = 11,
    eSASysIllegalToken = 12,
    eSASysTimeExpire = 13,
    eSASysSecureErrMax = 20,
} SASysCode;


typedef NSInteger SAResponseCode;
//The broadcast code is for SA telling the delegate to do something.
typedef enum
{
    eSABroadcastRetry = 1
    
} SABroadcastCode;

@protocol SAServiceLocator <NSObject>

@required
-(NSString*) lookupUrlForService:(NSString*)serviceType;

@end

@protocol SADelegate;

@protocol ServerAgentProtocol<NSObject>

@required
-(NSString*) serviceType;

-(NSInteger) totalBytes;

-(NSInteger) readBytes;

-(void) setRetryCount:(NSInteger) reties;

-(id)initWithDelegate:(id<SADelegate>) delegate andServiceLocator:(id<SAServiceLocator>) serviceLocator;

@end

@protocol SADelegate <NSObject>

@required
-(void) transactionFinishedWithAgent:(id<ServerAgentProtocol>) agent;

-(void) transactionFailedWithAgent:(id<ServerAgentProtocol>)agent reason:(SAFailReason) reason andNativeCode:(NSInteger)errCode;

@optional
-(void) serverAgent:(id<ServerAgentProtocol>)agent willRequest:(NSArray*) reqParams;

-(void) updateProgressWithAgent:(id<ServerAgentProtocol>)agent andStage:(SAStage)stage;

@end

@protocol SAHttpHandlerDelegate;

@protocol SAHttpHandler <NSObject>

@property (nonatomic,readonly)  NSDictionary            *responseHeaders;
@property (nonatomic,readonly)  NSInteger               errorCode;
@property (nonatomic,readonly)  NSInteger               expectBytes;
@property (nonatomic,readonly)  NSData*                 receivedData;
@property (nonatomic,readonly)  NSInteger               receivedBytes;
@property (nonatomic,assign)    NSInteger               retryCount;

//-(void)releaseConnection;

-(void)disconnect;

-(void)doPostWithDelegate:(id<SAHttpHandlerDelegate>)delegate request:(NSDictionary *)request postData:(NSData*)data url:(NSURL *)theURL withTimeout:(NSInteger) timeout;

-(void)doGetWithDelegate:(id<SAHttpHandlerDelegate>)delegate request:(NSDictionary *)request url:(NSURL *)theURL withTimeout:(NSInteger) timeout;

-(void)doPostWithDelegate:(id<SAHttpHandlerDelegate>)delegate request:(NSDictionary *)request filePath:(NSString*)filePath url:(NSURL *)theURL withTimeout:(NSInteger) timeout;

@end

@class HTTPSecureModel;

@protocol SAHttpHandlerDelegate<NSObject>
@optional
- (void)connectionDidFail:(id<SAHttpHandler>)handler;
- (void)connectionDidFinish:(id<SAHttpHandler>)handler;

@optional
- (void)connectionDidReceiveData:(id<SAHttpHandler>)theConnection;
- (void)connectionWillSendAuthentication:(HTTPSecureModel*) secureModel;
- (void)connectionDidFinishDownload:(id<SAHttpHandler>)theConnection atDestination:(NSString*) path;

@end

#define HTTPHandlerDelegate SAHttpHandlerDelegate

#endif
