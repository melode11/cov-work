//
//  ASIHttpHandler.h
//  AuroraPhone
//
//  Created by Yao Melo on 1/21/13.
//
//

#import <Foundation/Foundation.h>
#import "SAConstants.h"
@class ASIHTTPRequest;

@interface ASIHttpHandler : NSObject<SAHttpHandler>
{
    id<SAHttpHandlerDelegate> _delegate;
    ASIHTTPRequest *_requestRef;
    NSOperationQueue *_queue;
    NSRecursiveLock *_requestLock;
}

-(id)init;

-(id)initWithQueue:(NSOperationQueue*)queue;

@end
