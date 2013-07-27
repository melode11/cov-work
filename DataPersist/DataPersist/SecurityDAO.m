//
//  SecurityDAO.m
//  Annotation_iPad
//
//  Created by Yao Melo on 4/17/13.
//
//

#import "SecurityDAO.h"

@implementation SecurityDAO
@synthesize secureToken;
@synthesize allowFallback;
@synthesize secureType;

//no storage
-(void)store
{
    
}

-(void)load
{
    
}

-(void)clean
{
    self.secureToken = nil;
    self.secureType = eSecureNone;
    self.allowFallback = NO;
}

- (void)dealloc
{
    [secureToken release];
    [super dealloc];
}

@end
