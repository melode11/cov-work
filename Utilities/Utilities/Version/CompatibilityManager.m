//
//  CompatibilityManager.m
//  Utilities
//
//  Created by Yao Melo on 6/26/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "CompatibilityManager.h"
#import "Tool.h"

unsigned long CalcVersionValue(NSString *appVersion)
{
    unsigned long versionValue = 0;
    if([appVersion length] > 0)
    {
        unsigned long versions[3];
        char buf[32];
        [appVersion getCString:buf maxLength:32 encoding:NSUTF8StringEncoding];
        int nVersions = sscanf(buf, "%ld.%ld.%ld",versions,versions+1,versions+2);
        int counter = 0;
        for (int i = nVersions -1; i>=0; i--) {
            long v = versions[i];
            for (int j=0; j<counter; j++) {
                
                if(j == 0)
                {
                    v*= 1000000; //secondary version multiplier is large to leave the space for minor version.
                }
                else
                {
                    v*= 1000;
                }
            }
            versionValue+=v;
        }
    }
    return versionValue;
}

@implementation CompatibilityManager

@synthesize targetAppVersion;
@synthesize targetSipName;


static CompatibilityManager *sharedManager;


+ (CompatibilityManager *)sharedManager
{
	@synchronized(self)
	{
		if(sharedManager == nil)
		{
			sharedManager = [[self alloc]init];
		}
	}
	return sharedManager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    
	
	
}

- (void)dealloc
{
    //    [sipPassword release];
    //	[sipUserName release];
    //    [sipServer release];

	[targetAppVersion release];
    [super dealloc];
}

- (id)autorelease
{
    return self;
}

- (id)init
{
	if(self = [ super init])
	{
		
	}
	return self;
}


-(BOOL)isTargetSupportAnnotationCompression
{
    return versionValue >= 2305;
}

-(BOOL)isTargetSupportToggle
{
    return versionValue >= 2305;
}


-(BOOL)isTargetVersionLower
{
    return versionValue< CalcVersionValue([Tool getAppVersion]);
}

-(void)setTargetAppVersion:(NSString *)appVersion
{
    versionValue = CalcVersionValue(appVersion);
    [targetAppVersion release];
    targetAppVersion =[appVersion retain];
    DDLogInfo(@"Get target version,as text:%@, as value:%ld",targetAppVersion,versionValue);
}

@end
