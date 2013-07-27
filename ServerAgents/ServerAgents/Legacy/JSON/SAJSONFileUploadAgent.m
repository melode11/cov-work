//
//  SAJSONFileUploadAgent.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONFileUploadAgent.h"
#import "RemoteFileBuilder.h"
#import "DeviceProfile.h"

@implementation SAJSONFileUploadAgent
@synthesize remoteFile;
@synthesize isStopped;
@synthesize localFilePath;

-(id)initWithDelegate:(id<SADelegate>)delegate andServiceLocator:(id<SAServiceLocator>)serviceLocator
{
    self = [super initWithDelegate:delegate andServiceLocator:serviceLocator];
    if(self)
    {
        _handlerLock = [[NSRecursiveLock alloc]init];
        self.isStopped = NO;
    }
    return self;
}

-(void)requestUploadWithPath:(NSString *)fullPath andLoginName:(NSString*) loginname
{
    self.localFilePath = fullPath;
    [_loginname release];
    _loginname = [loginname retain];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:@"image/jpeg",@"content-type", nil];
    id<SAHttpHandler> handler = [self requestWithService:SERVICE_FILEUPLOAD headers:headers filePath:fullPath andTimout:SA_DEFAULT_TIMOUT];

    [_handlerLock lock];    
    [handler retain];
    _refHandler = handler;    
    [_handlerLock unlock];
}

-(void)requestUploadCRMODWithPath:(NSString *)fullPath andLoginName:(NSString*) loginname
{
    self.localFilePath = fullPath;
    [_loginname release];
    _loginname = [loginname retain];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:@"image/jpeg",@"content-type", nil];
    id<SAHttpHandler> handler = [self requestWithService:SERVICE_CRMODUPLOAD headers:headers filePath:fullPath andTimout:SA_DEFAULT_TIMOUT];
    
    [_handlerLock lock];    
    [handler retain];
    _refHandler = handler;    
    [_handlerLock unlock];
}

-(void)requestUploadWithData:(NSData*) data andFilename:(NSString*) filename loginName:(NSString*) loginname
{
    self.localFilePath = filename;
    [_loginname release];
    _loginname = [loginname retain];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:@"image/jpeg",@"content-type", nil];
    id<SAHttpHandler> handler = [self requestWithService:SERVICE_FILEUPLOAD headers:headers postOrGet:YES data:data andTimout:SA_DEFAULT_TIMOUT];     
    [_handlerLock lock];    
    [handler retain];
    _refHandler = handler;    
    [_handlerLock unlock];
}

-(void)parseBusinessObject:(NSDictionary *)dict code:(NSInteger)bizcode andTimeStamp:(NSString *)timestamp
{
    if(bizcode != 0)
    {
        [self markBusinessError:bizcode];
        return ;
    }
    self.remoteFile = [RemoteFileBuilder buildFromDict:dict];
}

-(NSURL *)lookupUrlForServiceType:(NSString *)serviceType
{
    NSString *urlStr = [_serviceLocator lookupUrlForService:serviceType]; 
   
    NSURL *url = [NSURL URLWithString:[urlStr stringByAppendingFormat:@"?fname=%@&loginname=%@&devicetype=%@",[[self.localFilePath lastPathComponent] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],_loginname,[[DeviceProfile Instance] deviceName]]];
    return url;
}

-(void)connectionDidFinish:(id<SAHttpHandler>)theConnection
{
    BOOL stopped = NO;
    [_handlerLock lock];
    stopped = self.isStopped;
    [_refHandler release];
    _refHandler = nil;
    [_handlerLock unlock];
    if(!stopped)
    {
        [super connectionDidFinish:theConnection];
    }
}

-(void)connectionDidFail:(id<SAHttpHandler>)theConnection
{
    BOOL stopped = NO;
    [_handlerLock lock];
    stopped = self.isStopped;
    [_refHandler release];
    _refHandler = nil;
    [_handlerLock unlock];
    if(!stopped)
    {
        [super connectionDidFail:theConnection];
    }
    
}

/*
 * Thread-safe to call this
 */
-(void)stopSending
{
    [_handlerLock lock];
    if(_refHandler)
    {
        [_refHandler disconnect];
        [_refHandler release];
        _refHandler = nil;
    }
    self.isStopped = YES;
    [_handlerLock unlock];
}

- (void)dealloc
{
    [_handlerLock release];
    [localFilePath release];
    [remoteFile release];
    [_loginname release];
    [super dealloc];
}

@end
