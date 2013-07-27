//
//  SAJSONFileUploadAgent.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONHttpAgent.h"
#import "SABizProtocols.h"
#import "SAConstants.h"

@interface SAJSONFileUploadAgent : SAJSONHttpAgent<SAFileUploadProtocol>
{
    @private
    id<SAHttpHandler> _refHandler;
    NSRecursiveLock *_handlerLock;
    NSString* _loginname;
}

@property (nonatomic,retain) RemoteFile* remoteFile;
@property (nonatomic,retain) NSString* localFilePath;
@property (nonatomic,assign) BOOL isStopped;

@end
