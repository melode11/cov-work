//
//  ClientFeature.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//feature codes definition
FOUNDATION_EXPORT NSString *const FC_DEBUG;
FOUNDATION_EXPORT NSString *const FC_ROTATION;
FOUNDATION_EXPORT NSString *const FC_LINKTODOC;
FOUNDATION_EXPORT NSString *const FC_SA2RIGHT;
FOUNDATION_EXPORT NSString *const FC_CRMOD;
FOUNDATION_EXPORT NSString *const FC_SHORTCUT;
FOUNDATION_EXPORT NSString *const FC_ANNOTATION;
//add by kuison for Thailand no audio issue.
FOUNDATION_EXPORT NSString *const FC_VOIP_PATCH;
//end of add
FOUNDATION_EXPORT NSString *const FC_TERMOFUSE;

//feature parameters key definition
FOUNDATION_EXPORT NSString *const FK_FLAG;
FOUNDATION_EXPORT NSString *const FK_LINK;

FOUNDATION_EXPORT NSString *const FK_ANNO_SHAPE;
FOUNDATION_EXPORT NSString *const FK_ANNO_PEN;
FOUNDATION_EXPORT NSString *const FK_ANNO_CALLOUT;
FOUNDATION_EXPORT NSString *const FK_ANNO_CLEAR;
FOUNDATION_EXPORT NSString *const FK_ANNO_ARROW;


FOUNDATION_EXPORT NSString *const FK_SA2_USERNAME;
FOUNDATION_EXPORT NSString *const FK_SA2_PASSWORD;

FOUNDATION_EXPORT NSString *const FK_VOIP_TAILAND;

FOUNDATION_EXPORT NSString *const FV_TERMOFUSE_EM;


@interface ClientFeature : NSObject

@property(nonatomic,retain) NSString* code;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* description;
@property(nonatomic,retain) NSString* version;
@property(nonatomic,retain) NSDictionary* parameters;

-(id)parameterForKey:(NSString*) key;

@end
