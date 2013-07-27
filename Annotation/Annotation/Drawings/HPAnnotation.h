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

#import <Foundation/Foundation.h>
#import "LAAttribute.h"
typedef enum _HPDrawingCapability {
    eDrawNone = 0,
    eDrawDirty = 0x1,
    eDrawClean = 0x2
}HPDrawingCapability;

@protocol  HPAnnotationDrawer;

extern NSString *const kHPAnnotationContentsUpdated;
@interface HPAnnotation : NSObject<LAAttribute> {

	@private
	BOOL isEditable;
	CGRect _bounds;
	CGFloat _strokeWidth;
    BOOL _isReceived;
    id<HPAnnotationDrawer> _drawer;
}
@property(nonatomic) NSInteger tag;
@property(nonatomic,readonly) AnnotationType annotationType;
@property(nonatomic) BOOL isReceived;
@property(nonatomic,readonly)UIColor *strokeColor;
@property(nonatomic,readonly)UIColor *fillColor;
@property(nonatomic,assign)BOOL isEditable;
@property(nonatomic,assign)CGRect bounds;
@property(nonatomic,assign)CGFloat strokeWidth;
@property(nonatomic,retain)id<HPAnnotationDrawer> drawer;
@property(nonatomic,readonly)HPDrawingCapability drawingCapability;
//!Initialization of brush properties
//-(id)initWithProperties:(NSDictionary*)inProperties;

-(id)initWithDrawer:(id<HPAnnotationDrawer>)drawer;

-(id)initWithDrawer:(id<HPAnnotationDrawer>)drawer andProperties:(NSDictionary*)inProperties;
//!Get all the properties of the brush
-(NSMutableDictionary*)properties;
//!Define rect for drawing
//-(void)drawInRect:(CGRect)inRect;
-(void)drawWithContext:(CGContextRef)context isDirty:(BOOL)isDirty outDirty:(CGRect*) outDirtyRect;

//!Moving point to point for free hand drawing
-(void)moveToPoint:(CGPoint)inPoint; 
//!return nil always
-(UIImage *)thumbnailImage;
//!return nil always
-(NSString *)resourcePath;
//!Do nothing.
-(void)updateContents:(id)inContents;
//!Do nothing.
-(void)updateCFTypeContents:(CFTypeRef)inContents;

//Editing
//!Do nothing.
-(void)beginEditing;
//!Do nothing.
-(void)endEditing;
//!Do nothing.
-(void)loadPathAnnotations;



@end

@protocol HPAnnotationDrawer <NSObject>

//!notify when annotation itself changes
- (void) updateAnnotation: (HPAnnotation*) annotation;
//!notify when all changes to annotation is done.
- (void) commitAnnotation:(HPAnnotation*) annotation;

- (void) clearAnnotations;

@end
