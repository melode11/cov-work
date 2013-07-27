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

#import <UIKit/UIKit.h>
#import "DeviceProfile.h"
#import "constants.h"

@implementation DeviceProfile

@synthesize TypeOfDevice;
@synthesize UDID;
@synthesize platform;
@synthesize apnsToken;
@synthesize deviceName;

static DeviceProfile *instance = nil;
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Create shared instance of the class.
 * RETURN: Shared instance of the class. 
 --------------------------------------------------------------------------
 */
#ifndef __clang_analyzer__
+ (DeviceProfile *)Instance
{
    @synchronized ( self ) 
	{
        if ( instance == nil ) {
            [[self alloc] init];
        }
    }
    return instance;
}
#endif
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:#import "LAUtilities.h"
 1. Init content of the class.
 * RETURN: Shared instance of the class. 
 --------------------------------------------------------------------------
 */
- (DeviceProfile *)init
{
    if ( instance != nil ) 
	{ 
		// DO NOTHING; 
		
	} 
	else if ((self = [super init]))
	{
		instance = self;
        /* Whatever class specific here */
		
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
		{
			TypeOfDevice = IPHONE;
            
		}
		else {
			TypeOfDevice = IPAD;
        }

//		self.UDID = [UIDevice currentDevice].uniqueIdentifier;
		self.platform = [NSString stringWithFormat:@"%@%@",
						 [UIDevice currentDevice].systemName,
						 [UIDevice currentDevice].systemVersion];
		// TODO: Potential memory leak. Fix it.
		NSString *token = [[NSString alloc]
						  initWithString:@"d64773372055d9d671c47c59da1d5943a8e77beda3a004c2ff56094dd42b927b"];
		self.apnsToken = token;
		[token release];

        
	}
	return instance;
}

-(NSString *)deviceName
{
    if(self.TypeOfDevice == IPAD)
    {
        return DEVICENAME_IPAD;    
    }
    else if(self.TypeOfDevice == IPHONE)
    {
        return DEVICENAME_IPHONE;
    }
    else {
        return nil;
    }

}

@end
