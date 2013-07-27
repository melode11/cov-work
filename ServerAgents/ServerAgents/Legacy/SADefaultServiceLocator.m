//
//  SADefaultServiceLocator.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SADefaultServiceLocator.h"
#import "SABizProtocols.h"

static SADefaultServiceLocator* sharedDefaultServiceLocator;

@implementation SADefaultServiceLocator
@synthesize baseUrl;



+(SADefaultServiceLocator *)sharedInstance
{
    if(sharedDefaultServiceLocator == nil)
    {
        @synchronized(self)
        {
            if(sharedDefaultServiceLocator == nil)
            {
                sharedDefaultServiceLocator = [[SADefaultServiceLocator alloc]init];
            }
        }
    }
    return sharedDefaultServiceLocator;
}

-(NSString *)lookupUrlForService:(NSString *)serviceType
{
    if([serviceType isEqualToString:SERVICE_WEBAUTHENTICATE])
    {
        return @"https://webmail.covidien.com";
    }
    return [self.baseUrl stringByAppendingFormat:@"/aurora/ws/%@",serviceType];
    
}

-(void)release
{
    
}

-(void)dealloc
{
    self.baseUrl = nil;
    [super dealloc];
}

@end
