//
//  ClientFeature.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientFeature.h"

NSString *const FC_DEBUG = @"debug";
NSString *const FC_ROTATION = @"rotation";
NSString *const FC_LINKTODOC = @"link_to_doc";
NSString *const FC_SA2RIGHT = @"sa2_right";
NSString *const FC_CRMOD = @"crmod";
NSString *const FC_SHORTCUT = @"shortcut";
NSString *const FC_ANNOTATION = @"annotation";
//add by kuison for Thailand no audio issue.
NSString *const FC_VOIP_PATCH = @"voip";
//end of add
NSString *const FC_TERMOFUSE = @"term_of_use";

NSString *const FK_FLAG = @"flag";
NSString *const FK_LINK = @"link";

NSString *const FK_ANNO_SHAPE = @"SHAPE";
NSString *const FK_ANNO_PEN = @"PEN";
NSString *const FK_ANNO_CALLOUT = @"CALLOUT";
NSString *const FK_ANNO_CLEAR = @"CLEAR";
NSString *const FK_ANNO_ARROW = @"ARROW";

NSString *const FK_SA2_USERNAME = @"sa2_username";
NSString *const FK_SA2_PASSWORD = @"sa2_password";

NSString *const FK_VOIP_TAILAND = @"ThailandPatch";

NSString *const FV_TERMOFUSE_EM = @"EM";

@implementation ClientFeature

@synthesize code;
@synthesize name;
@synthesize description;
@synthesize version;
@synthesize parameters;


-(id)parameterForKey:(NSString *)key
{
    return [self.parameters objectForKey:key];
}

-(void)dealloc
{
    self.code = nil;
    self.name = nil;
    self.description = nil;
    self.version = nil;
    self.parameters = nil;
    [super dealloc];
}
@end
