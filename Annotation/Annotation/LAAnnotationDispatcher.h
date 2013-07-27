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
#import "LAAnnotation.h"
#import "LVConstants.h"
#import "LATextAnnotation.h"
#import "LAUtilities.h"
#import "LADrawingController.h"
#import "LAAttribute.h"


@protocol LAAnnotationDispatcherDelegate <NSObject>

-(UIView*)annotationContainer;

-(void) sendAnnotation:(id<LAAttribute>)annotation withExtra:(NSString*)data;

@end




@interface LAAnnotationDispatcher : NSObject <LATextAnnotationDelegate>{
    
	LAAnnotation* selectedAnnotation;
	NSInteger _annotationCount;
	AnnotationTool _annotationTool;
	//HPDrawingView *_drawingView;
	NSMutableDictionary *annotationDict;
	NSTimer *annotationTimer;
	NSMutableArray *pointArray;
	NSMutableArray *xmppAnnotationArray;
    BOOL isAnnotationsPresence;
    
    //! This boolean will decide weather the option menu will get displayed on annotation view or not
    BOOL needToShowOptionMenu;
    NSTimeInterval latestUiTime;
    //    PointConerter convertor;
}
@property(nonatomic,assign) LADrawingController *drawingController;
@property(nonatomic,retain) LAAnnotation * selectedAnnotation;
@property(nonatomic,assign) NSTimer *annotationTimer;
@property(nonatomic, retain) NSMutableArray *xmppAnnotationArray;
@property(nonatomic,assign) BOOL isAnnotationsPresence;
@property(nonatomic, assign) id<LAAnnotationDispatcherDelegate> delegate;
@property (nonatomic,assign) BOOL needToShowOptionMenu;
@property(nonatomic,retain) id<HPAnnotationDrawer> annotationDrawer;
@property(nonatomic,retain) NSTimer *trackTimer;

//Add text annoation
- (void)addTextAnnotation:(NSString *)inText withFont:(UIFont *)inFont
				   withId:(NSInteger)inTag atCenter:(CGPoint)inCenter;
//Add drawing annotation.
- (void)addAnnotationForType:(AnnotationType) inType;
//!Create circle from the incomming annotation
- (void)addCircleAnnotationWithRadius:(NSInteger)inRadius;
//!Create data from existing annotation.
//- (NSData *)getDataFromTheAnnotation:(LAAnnotation *)inAnnotation withType:(int)inType withID:(NSInteger)inID;
//!Clear all annotation when pressed clear button.
- (void)clearAllAnnotations;
//!Update point to existing annotion to updated
- (void)annotationUpdateWithID:(NSInteger)inID withUpdatedPoints:(NSDictionary*)pointsDictionary;
//!Get annoation from containg touch point.
- (UIView*)getSelectedAnnotationForPoint:(NSInteger)inTag;
//!Draw annotation with incomming dictionary.
- (void)drawAnnotationWithDict:(NSDictionary *)inDict forType:(AnnotationType)inType withID:(NSInteger)inID;

//!Return center point to create annotation.
- (CGPoint)getCenterPointToCreateAnnotation:(NSDictionary*)inDict;
//!Catch incomming circle annotation and display.
- (void)addCircleAnnotationWithRadius:(NSInteger)inRadius withCenterPoint:(CGPoint)inPoint
							   withID:(NSInteger)inID ifSelf:(BOOL)changeColor;
//!Catch incomming circle annotation and display.
//- (void)addCircleAnnotationWithDictionary:(NSDictionary*)propertyDic ifSelf:(BOOL)changeColor;
//!Create new tag for free hand drawing for identification.
- (NSInteger)tagForFreehand;
//!Create JSON string from point array
- (NSString*) createJSONStringFrom:(NSArray*)pointArray withOption:(NSString*)optional;
//!Get message from the text annotation.
- (NSString *)getMessageForAnnotation:(NSDictionary*)inDict;

- (void)installDrawer:(id<HPAnnotationDrawer>) drawer;

- (void)touchEvent:(LATouchEvent)event withPoints:(CGPoint*)points andCount:(NSUInteger)touchCount;

#pragma mark -
#pragma mark Annotations
//!Set annotation tool when touch the tool button.
- (void)setAnnotationTool:(AnnotationTool)inTool;
//!Setting the timer to send annotations.
- (void)setTimerToSendAnnotation;
//!send coordinate points to the xmpp server.
- (void)sendPointsToXMPPServer:(NSTimer*)timer;


@end
