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

#import "LAAnnotationDispatcher.h"
#import "DeviceProfile.h"
#import "LACircle.h"
#import <QuartzCore/CAAnimation.h>
#import "LATextAnnotation.h"
#import "LVConstants.h"
#import "constants.h"
#import "LABitmapDrawingView.h"
#import "LAArrow.h"
#import "CallTimer.h"
#import "CompatibilityManager.h"
#import "CompatibilityManager+Annotation.h"
#import <SBJson.h>

#define kSourceAnnotationTag 500
#define kDestAnnotationTag 1500

extern NSString const *kLVAnnotationPath;
extern NSString const *kLVAnnotationBounds;


static inline id CGPointToString(CGPoint point)
{
    CGSize targetSize = [[CompatibilityManager sharedManager] targetVideoDimension];
    point.x = point.x * targetSize.width/ X_PIX_NORMALIZED;
    point.y = point.y * targetSize.height/Y_PIX_NORMALIZED;
    return NSStringFromCGPoint(point);
}

static inline id CGPointToNumber(CGPoint point)
{
    return NSNumberForPoint(point);
}

static inline void QueuePoint(NSMutableArray* array, CGPoint point)
{
    point.x/=[LAUtilities getDeviceRatioX];
    point.y/=[LAUtilities getDeviceRatioY];
    if([[CompatibilityManager sharedManager] isTargetSupportAnnotationCompression])
    {
        [array addObject:CGPointToNumber(point)];
    }
    else
    {
        [array addObject:CGPointToString(point)];
    }
    
}

static inline CGPoint NextNewAnnotationPosition(NSInteger annotationCount)
{
    CGFloat yOffset = ((annotationCount/60) % 4)*40;
    CGFloat xOffset = (annotationCount%60)*3;
    yOffset += xOffset;
    return CGPointMake(200.0f - xOffset, 100.0f+yOffset);
}

void ParseDrawingAnnotation(NSTimeInterval *time,NSMutableArray** array)
{
    
}


@interface UIView(LAAnnotation)

@property (readonly,readonly) NSInteger tagForSend;
@end

@implementation UIView(LAAnnotation)
    

-(NSInteger)tagForSend
{
    if([self isKindOfClass:[LAAnnotation class]])
    {
        return self.tag + (((LAAnnotation*)self).isReceived ? (kSourceAnnotationTag - kDestAnnotationTag) : (kDestAnnotationTag - kSourceAnnotationTag));
    }
    return self.tag;    
}

@end


@interface LAAnnotationDispatcher(Private)
- (void)findSelectedAnnotationForPoint:(CGPoint)inPoint;
//- (void)sendingObjectAnnotationUpdateWithCenterPoint:(CGPoint)inPoint withType:(int)type;
- (void)addTextAnnotation;
- (void)moveWithSize:(CGSize)size byTouch:(CGPoint) touch inBounds:(CGRect) boundingBox forCenter:(CGPoint*) outCenter;
-(void)addDrawingAnnotationWithDict:(NSDictionary*) properties;

@property (nonatomic,readonly) NSArray* subviews;
@property (nonatomic,readonly) CGRect bounds;

@end

@implementation LAAnnotationDispatcher
@synthesize selectedAnnotation;
@synthesize delegate = _delegate;
@synthesize annotationTimer;
@synthesize xmppAnnotationArray;
@synthesize isAnnotationsPresence;
@synthesize needToShowOptionMenu;
@synthesize annotationDrawer;
@synthesize trackTimer;
@synthesize drawingController = _drawingController;

BOOL userWantsOptionViewForAnnotations;
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Initialize and set view.
 * RETURN: id
 --------------------------------------------------------------------------
 */
- (id)init
{
    if ((self = [super init]))
	{
        // Initialization code

        
		[self setAnnotationTool:eNone];
		annotationDict = [[NSMutableDictionary alloc]initWithCapacity:0];
		//Intializing the point array which will have all the points for a annotation while movement
		pointArray = [[NSMutableArray alloc]initWithCapacity:0];
		xmppAnnotationArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}


- (void)dealloc {
	RELEASE(annotationTimer);
	RELEASE(pointArray);
	RELEASE(xmppAnnotationArray)
    [trackTimer release];
    self.annotationDrawer = nil;
    [super dealloc];

       
}

#pragma mark - Adapters for UIView operations.
-(void)addSubview:(UIView*)child
{
    [[self.delegate annotationContainer] addSubview:child];
}

-(UIView*)viewWithTag:(NSInteger)tag
{
    return [[self.delegate annotationContainer] viewWithTag:tag];
}

-(NSArray*)subviews
{
    return [self.delegate annotationContainer].subviews;
}

-(CGRect)bounds
{
    return [self.delegate annotationContainer].bounds;
}

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Add circle
 * RETURN: void
 --------------------------------------------------------------------------
 */
- (void)addAnnotationForType:(AnnotationType) inType
{
    //add basic protection of annotation counts.
    if([self.subviews count]>150)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Too many annotations!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    if(inType == eArrow)
    {
        [self addArrowAnnotation];
    }
    else if(inType == eCircle)
	{
		if([[DeviceProfile Instance] TypeOfDevice] == IPAD)
		{
			[self addCircleAnnotationWithRadius:30*[LAUtilities getAspectRatio]];
		}
		else {
			[self addCircleAnnotationWithRadius:30];
		}
        
		
	}
	else if(inType == eText)
	{
		[self addTextAnnotation];
	}
    
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Add circle with redius
 * RETURN: void
 --------------------------------------------------------------------------
 */
- (void)addCircleAnnotationWithRadius:(NSInteger)inRadius
{
	isAnnotationsPresence = YES;

	_annotationCount++;
    CGPoint origin = NextNewAnnotationPosition(_annotationCount);
	LACircle * circle = [[LACircle alloc] 
						 initWithFrame:CGRectMake(origin.x, origin.y, inRadius * 2.0f, inRadius * 2.0f)
						 withRadius:inRadius];

	
//	if([[DeviceProfile Instance] TypeOfDevice] == IPAD)
//	{
//		circle.tag = kIpadAnnotationTag + _annotationCount;
//	}
//	else 
//	{
//		circle.tag = kIphoneAnnotationTag + _annotationCount;
//	}
    circle.tag = kSourceAnnotationTag + _annotationCount;
	[self addSubview:circle];
	[circle setNeedsDisplay];
	[circle release];
	
	NSMutableArray *arr = [NSMutableArray array];

    QueuePoint(arr, circle.center);
    inRadius/=[LAUtilities getAspectRatio];
	NSString *str = [self createJSONStringFrom:arr withOption:nil];
	[self.delegate sendAnnotation:circle withExtra:str];
    
	
	[self setAnnotationTool:eNone];
}

-(void) addArrowAnnotation
{
    isAnnotationsPresence = YES;
    
	_annotationCount++;
    CGPoint center = NextNewAnnotationPosition(_annotationCount);
	LAArrow * arrow = [[LAArrow alloc] initWithCenter:center ifReceived:NO];
						 
    
	
    //	if([[DeviceProfile Instance] TypeOfDevice] == IPAD)
    //	{
    //		circle.tag = kIpadAnnotationTag + _annotationCount;
    //	}
    //	else
    //	{
    //		circle.tag = kIphoneAnnotationTag + _annotationCount;
    //	}
    arrow.tag = kSourceAnnotationTag + _annotationCount;
	[self addSubview:arrow];
	[arrow release];
	NSMutableArray *arr = [NSMutableArray array];
    QueuePoint(arr, center);
	NSString *str = [self createJSONStringFrom:arr withOption:nil];
	[self.delegate sendAnnotation:arrow withExtra:str];
	
	[self setAnnotationTool:eNone];
}

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Add Text Annotation
 * RETURN: void
 --------------------------------------------------------------------------
 */
- (void)addTextAnnotation
{
	
	
	float width = 0;
	float height = 0;
    CGAffineTransform transform = CGAffineTransformMakeScale([LAUtilities getDeviceRatioX]*X_PIX_NORMALIZED/X_PIX_IPAD, [LAUtilities getDeviceRatioY]*Y_PIX_NORMALIZED/Y_PIX_IPAD);
	
    width = (193.0f) ;
    height = (165.0f);
		//inRadius = inRadius / 1.7227f;
	LATextAnnotation *textAnnotation = [[LATextAnnotation alloc] 
										initWithFrame:CGRectMake(50.0f, 150.0f, width, height)];
    textAnnotation.transform = transform;
	textAnnotation.delegate = self;
	
	
	[self addSubview:textAnnotation];
	[textAnnotation setNeedsDisplay];
	[textAnnotation release];
	[self setAnnotationTool:eNone];
}

#pragma mark -
#pragma mark LATextAnnotationDelegate
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Send text annotation to server
 * RETURN: void
 --------------------------------------------------------------------------
 */
- (void)annotation:(LATextAnnotation *)inAnnotation didSendAnnotationText:(NSString *)intext withFont:(UIFont *)inFont 
{
    _annotationCount++;
//    if([[DeviceProfile Instance] TypeOfDevice] == IPAD)
//	{
//		inAnnotation.tag = kIpadAnnotationTag + _annotationCount;
//	}
//	else 
//	{
//		inAnnotation.tag = kIphoneAnnotationTag + _annotationCount;
//	}
    inAnnotation.tag = kSourceAnnotationTag +_annotationCount;
	isAnnotationsPresence = YES;
	CGPoint centerPoint	= inAnnotation.center;
	//Modified center point
//	CGPoint modifiedPoint = centerPoint;
//	modifiedPoint.x = (modifiedPoint.x - (193/2)) + 102;
//	modifiedPoint.y += inAnnotation.frame.size.height/2;
	NSString *messageText = [NSString stringWithString:intext];
	NSMutableArray *arr = [NSMutableArray array];
    QueuePoint(arr, centerPoint);
    NSString *str = [self createJSONStringFrom:arr withOption:messageText];
   
	[self.delegate sendAnnotation:inAnnotation withExtra:str];
}

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Create JSON string from point array
 * RETURN: json string
 --------------------------------------------------------------------------
 */
-(NSString*) createJSONStringFrom:(NSArray*)centerPointArray withOption:(NSString*)optional
{
    
    if(![[CompatibilityManager sharedManager] isTargetSupportAnnotationCompression])
    {
        return [self createJSONStringOldFrom:centerPointArray withOption:optional];
    }
	NSMutableDictionary *aMutabledict = [[NSMutableDictionary alloc]initWithCapacity:1];
    DDLogInfo(@"send points time:%lf",latestUiTime);
	[aMutabledict setObject:[LAUtilities stringWithShiftedPoints:centerPointArray] forKey:@"COMPRESS_P"];
    [aMutabledict setObject:[NSNumber numberWithDouble:latestUiTime] forKey:@"TIM"];
    if([optional length]>0)
    {
        [aMutabledict setObject:optional forKey:@"O"];
    }
	NSString *json = ([aMutabledict JSONRepresentation]);
    [aMutabledict release];
    return json;
}


-(NSString*) createJSONStringOldFrom:(NSArray*)centerPointArray withOption:(NSString*)optional
{
    NSDictionary *aDict;
	NSMutableDictionary *aMutabledict = [[NSMutableDictionary alloc]initWithCapacity:1];
	
	
    int count = 1;
	for (id point in centerPointArray)
	{
        if(![point isKindOfClass:[NSString class]])
        {
            continue;
        }
		if([optional length] > 0)
		{
			aDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     optional,@"O",
                     point,@"P",nil];
		}
		else
		{
			aDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     point,@"P",nil];
            
		}
        [aMutabledict setObject:aDict forKey:[NSString stringWithFormat:@"%d",count]];
		count++;
	}
    [aMutabledict setObject:[NSString stringWithFormat:@"%d",count-1] forKey:@"count"];
    NSString *json = ([aMutabledict JSONRepresentation]);
    [aMutabledict release];
    return json;
}

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Clear all annotation
 * RETURN: void
 --------------------------------------------------------------------------
 */
-(void)clearAllAnnotations
{
    [self clearAllAnnotationsWithInputClosed:YES];
}

- (void)clearAllAnnotationsWithInputClosed:(BOOL)isCloseInput
{
	isAnnotationsPresence = NO;
    _annotationCount = 0;
    [annotationTimer invalidate];
    annotationTimer = nil;
	[self.drawingController clearDrawingPath];

    
	//[[HPBitmapDraw sharedBitmap] clearBitmap];
    [annotationDrawer clearAnnotations];
    [self setAnnotationTool:eNone];
	NSArray *annotations = [self subviews];
    
    @synchronized(pointArray)
    {
        [pointArray removeAllObjects];
    }
    
	for(NSInteger index = 0; index < [annotations count]; index++)
	{
		UIView *subView = [annotations objectAtIndex:index];
		if([[subView class] isSubclassOfClass:[LAAnnotation class]])
		{
            if ([subView class] == [LATextAnnotation class]) {
                if (isCloseInput || ![[subView viewWithTag:100] isFirstResponder]) {
                    [subView removeFromSuperview];
                    subView.tag =-1;
                }
            }
            else
            {
                [subView removeFromSuperview];
                subView.tag =-1;
            }
		}
	}
}

#pragma mark -
#pragma mark Touch Events

- (void)touchEvent:(LATouchEvent)event withPoints:(CGPoint *)points andCount:(NSUInteger)touchCount
{
    if(touchCount<=0)
    {
        return;
    }
	[annotationTimer invalidate];
	annotationTimer = nil;
	CGPoint touchPoint = points[0];
	CGPoint centerPoint;
    AnnotationType type = _annotationTool;
    if(self.selectedAnnotation)
    {
        type =self.selectedAnnotation.annotationType;
    }
	switch(type)
	{
		case eCircle:
        case eArrow:
        case eText:
		{
            NSTimeInterval uiTimestamp = [[NSDate date] timeIntervalSinceDate:[CallTimer callStartTime]];
            if(uiTimestamp > self.selectedAnnotation.uiTimestamp)
            {
                latestUiTime = uiTimestamp;
                [self.selectedAnnotation setUiTimestamp:uiTimestamp];
                
                [self moveWithSize:self.selectedAnnotation.frame.size byTouch:touchPoint inBounds:self.bounds forCenter:&centerPoint];
              
                    self.selectedAnnotation.center = centerPoint;
                    @synchronized(pointArray)
                    {
                        QueuePoint(pointArray, centerPoint);
                        
                    }
              
            }
            [self sendPointsToXMPPServer:nil];

		}
			break;						
		case eDrawing:
		{

            NSInteger tag = [self tagForFreehand];
            isAnnotationsPresence = YES;
            
            [self.drawingController setDrawingTag:tag];

            [self.drawingController touchDrawer:self.annotationDrawer withEvent:event points:points andCount:touchCount];

			break;
		
		}
        default:
        {
        }
        break;
            // We always want to go back to the drawing tool
    }
    self.selectedAnnotation = nil;
    [self setAnnotationTool:eDrawing];

}

-(void)moveWithSize:(CGSize)size byTouch:(CGPoint)touch inBounds:(CGRect)boundingBox forCenter:(CGPoint *)outCenter
{
    CGFloat halfWidth = size.width/2;
    CGFloat halfHeight = size.height/2;
    CGRect testViewRect = CGRectMake(touch.x - halfWidth, touch.y - halfHeight,size.width,size.height);
    if(testViewRect.origin.x < boundingBox.origin.x)
    {
        outCenter->x = boundingBox.origin.x + halfWidth;
    }
    else if(testViewRect.origin.x + testViewRect.size.width> boundingBox.origin.x + boundingBox.size.width)
    {
        outCenter->x = boundingBox.origin.x + boundingBox.size.width - halfWidth;
    }
    else {
        outCenter->x = touch.x;
    }
    
    if(testViewRect.origin.y < boundingBox.origin.y)
    {
        outCenter->y = boundingBox.origin.y + halfHeight;
    }
    else if(testViewRect.origin.y + testViewRect.size.height> boundingBox.origin.y + boundingBox.size.height)
    {
        outCenter->y = boundingBox.origin.y + boundingBox.size.height - halfHeight;
    }
    else {
        outCenter->y = touch.y;
    }
}

#pragma mark -
#pragma mark Annotations
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Generate new tag for freehand drawing
 * RETURN: int
 --------------------------------------------------------------------------
 */
- (NSInteger)tagForFreehand
{
//	if([[DeviceProfile Instance] TypeOfDevice] == IPAD)
//	{
//		return (kIpadAnnotationTag + (++_annotationCount));
//	}
//	else 
//	{
//		return (kIphoneAnnotationTag + (++_annotationCount));
//	}
    return kSourceAnnotationTag + (++_annotationCount);
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Set annotation tool to "_annotationTool" when select annotation tool button
 * RETURN: void
 --------------------------------------------------------------------------
 */
- (void)setAnnotationTool:(AnnotationTool)inTool
{
	_annotationTool = inTool; 
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Select containing view at touch point.
 * RETURN: Annoation View
 --------------------------------------------------------------------------
 */
- (UIView*)getSelectedAnnotationForPoint:(NSInteger)inTag
{
	NSArray *annotations = [self subviews];
	for(NSInteger index = 0; index < [annotations count]; index++)
	{
		UIView *subView = [annotations objectAtIndex:index];
		if([subView class] != [UIImageView class])
		{
			
			if(subView.tag == inTag)
			{
				return subView;
				DDLogVerbose(@"%d",self.selectedAnnotation.tag);
				break;
			}
		}
	}
	return nil;
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Select containing view at touch point.
 * RETURN: Annoation View
 --------------------------------------------------------------------------
 */
- (void)findSelectedAnnotationForPoint:(CGPoint)inPoint
{
	NSArray *annotations = [self subviews];
	self.selectedAnnotation = nil;
	for(NSInteger index = [annotations count] - 1; index >=0 ; index--)
	{
		UIView *subView = [annotations objectAtIndex:index];
		if([subView isKindOfClass:[LAAnnotation class]])
		{
			CGRect subViewFrame = subView.frame;
			DDLogVerbose(@"Tab of Subview %d", subView.tag);
			if(CGRectContainsPoint(subViewFrame, inPoint))
			{
				self.selectedAnnotation = (LAAnnotation*)subView;
				if ([self.selectedAnnotation isKindOfClass:[LACircle class]]) {
					[self setAnnotationTool:eCircle];
				}
				else if ([self.selectedAnnotation isKindOfClass:[LATextAnnotation class]])
				{
					[self setAnnotationTool:eText];
				}
                else if([self.selectedAnnotation isKindOfClass:[LAArrow class]])
                {
                    [self setAnnotationTool:eArrow];
                }
				break;
			}
		}
	}
}


/** 
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Create and add circle
 * RETURN: Void
 --------------------------------------------------------------------------
 */
- (void)addCircleAnnotationWithRadius: (NSInteger)inRadius
					  withCenterPoint: (CGPoint)inPoint 
							   withID: (NSInteger)inID
							   ifSelf: (BOOL)changeColor
{
    if (inRadius != 0)
    {
        isAnnotationsPresence = YES;
        inPoint.x = inPoint.x * [LAUtilities getDeviceRatioX];
        inPoint.y = inPoint.y * [LAUtilities getDeviceRatioY];
        inRadius = inRadius * [LAUtilities getAspectRatio];
        LACircle * circle = [[LACircle alloc] initWithFrame:CGRectMake(0, 0, inRadius * 2.0f, inRadius * 2.0f) withRadius:inRadius ifSelf:changeColor];
        circle.center = inPoint;//CGPointMake(xPosition, yPosition);;
        circle.tag = inID;
        [self addSubview:circle];
        [circle setNeedsDisplay];
        [circle release];	
    }
}

- (void)addArrowAnnotationWithCenterPoint:(CGPoint)inPoint withID:(NSInteger) inID ifSelf:(BOOL)changeColor
{
    isAnnotationsPresence = YES;
    inPoint.x*=[LAUtilities getDeviceRatioX];
    inPoint.y*=[LAUtilities getDeviceRatioY];
    LAArrow *arrow = [[LAArrow alloc] initWithCenter:inPoint ifReceived:changeColor];
    arrow.tag = inID;
    [self addSubview:arrow];
    [arrow release];
}


/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Create and add text annotation
 * RETURN: Void
 --------------------------------------------------------------------------
 */
- (void)addTextAnnotation: (NSString *)inText 
				 withFont: (UIFont *)inFont 
				   withId: (NSInteger)inTag 
				 atCenter: (CGPoint)inCenter
{
    if (inText && [inText length] > 0) {
        float width = 193;
        float height = 165;
        CGAffineTransform transform = CGAffineTransformMakeScale([LAUtilities getDeviceRatioX]*X_PIX_NORMALIZED/X_PIX_IPAD, [LAUtilities getDeviceRatioY]*Y_PIX_NORMALIZED/Y_PIX_IPAD);
        isAnnotationsPresence = YES;
        LATextAnnotation *textAnnotation = [[LATextAnnotation alloc] initWithFrame:CGRectMake(0, 0, width, height) 
                                                                          withText:inText font:inFont isReceived:YES];
        textAnnotation.transform = transform;
        textAnnotation.center = inCenter;// CGPointMake(xPosition, yPosition);
        textAnnotation.tag = inTag;
        [self addSubview:textAnnotation];
        [textAnnotation setNeedsDisplay];
        [textAnnotation release];
    }
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Calculate center point of annotation
 * RETURN: point
 --------------------------------------------------------------------------
 */
-(CGPoint)getCenterPointToCreateAnnotation:(NSDictionary*)inDict
{
    NSDictionary *info = [inDict objectForKey:@"INF"];
    NSString* base64Points = [info objectForKey:@"COMPRESS_P"];
    if(base64Points)
    {
        return CGPointFromNumber([[LAUtilities pointsWithString:base64Points] objectAtIndex:0]);
    }
    else //for backward compatibility
    {
        return CGPointFromString([[info valueForKey:@"1"] valueForKey:@"P"]);
    }
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Get message from text annotation
 * RETURN: string
 --------------------------------------------------------------------------
 */
-(NSString *)getMessageForAnnotation:(NSDictionary*)inDict
{
    NSDictionary *info = [inDict objectForKey:@"INF"];
    NSString *message = [info objectForKey:@"O"];
    if(message)
    {
        return message;
    }
    else //for backward compatibility
    {
        return [[info valueForKey:@"1"] valueForKey:@"O"];
    }
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Draw annotation according to screen size by maitaning aspect ratio
 * RETURN: Void
 --------------------------------------------------------------------------
 */
- (void)drawAnnotationWithDict:(NSDictionary *)inDict forType:(AnnotationType)inType withID:(NSInteger)inID
{
    if (inID != 0) {//inID must be non zero
//        if (_annotationCount == 0) {
//            //This is solve COVD-597
//            if (inID % kSourceAnnotationTag != 1)
//            {
//                    return;
//            }
//        }
        _annotationCount++;
        CGPoint centerPoint = [self getCenterPointToCreateAnnotation:inDict];
        CGSize targetSize = [[CompatibilityManager sharedManager] targetVideoDimension];
        centerPoint.x = centerPoint.x *X_PIX_NORMALIZED / targetSize.width;
        centerPoint.y = centerPoint.y *Y_PIX_NORMALIZED / targetSize.height;
        switch (inType) {
            case eCircle:
            {
                NSInteger radius =  [[inDict valueForKey:@"DIM"]intValue];

                UIView* drawView = [self getSelectedAnnotationForPoint:inID];
                
                DDLogVerbose(@"selectedAnnotation.tag %d",drawView.tag);
                if (drawView.tag != inID)
                    [self addCircleAnnotationWithRadius:radius withCenterPoint:centerPoint withID:inID ifSelf:YES];
                else 
                {
                    [self annotationUpdateWithID:inID withUpdatedPoints:inDict];
                }
                
            }
                break;
            case eArrow:
            {
                UIView* drawView = [self getSelectedAnnotationForPoint:inID];
                DDLogInfo(@"selectedAnnotation.tag %d",drawView.tag);
                if (drawView.tag != inID)
                    [self addArrowAnnotationWithCenterPoint:centerPoint withID:inID ifSelf:YES];
                else
                {
                    [self annotationUpdateWithID:inID withUpdatedPoints:inDict];
                }
                
                break;
            }
            case eText:
            {
                               //Added By Hank
//                if ([SIPControllerManager sharedManager].isP2P == NO) {
//                    if ([[DeviceProfile Instance] TypeOfDevice] == IPHONE) 
//                    {
//                        DDLogVerbose(@"updating for iphone=============================");
//                        centerPoint.x = centerPoint.x * X_RATIO;
//                        centerPoint.y = (centerPoint.y) * Y_RATIO;
//                    
//                    }	
//                    else
//                    {
//                        DDLogVerbose(@"updating for ipad=============================");
//                        centerPoint.x = (centerPoint.x) / X_RATIO;
//                        centerPoint.y = (centerPoint.y) / Y_RATIO;
//                    }
//                }
                //End
                centerPoint.x = centerPoint.x * [LAUtilities getDeviceRatioX];
                centerPoint.y = centerPoint.y * [LAUtilities getDeviceRatioY];
                //restore center point
//                CGPoint restorePoint = centerPoint;
//                restorePoint.x = restorePoint.x - 102 + (193/2);
//                restorePoint.y -= 165/2;
//                
                //////////////////////
                
                UIView* drawView = [self getSelectedAnnotationForPoint:inID];
                
                UIFont *font = [UIFont boldSystemFontOfSize:17.0f ];//[inDict objectForKey:kFontkey];
                
                
                if (drawView.tag != inID)
                {
                    NSString *annotationText = [self getMessageForAnnotation:inDict];
                    [self addTextAnnotation:annotationText withFont:font withId:inID atCenter:centerPoint];
                }
                else
                {
                    [self annotationUpdateWithID:inID withUpdatedPoints:inDict];
                }
            }
                break;
            case eDrawing:
            {
                [self addDrawingAnnotationWithDict:inDict];
            }
                break;
            default:
                break;
        }
    }
}

-(void)addDrawingAnnotationWithDict:(NSDictionary*) inDict
{
    isAnnotationsPresence = YES;
    NSDictionary* properties =[inDict valueForKey:@"INF"];
    
    HPPathAnnotation* pathAnnotation = [[HPPathAnnotation alloc] initWithDrawer:self.annotationDrawer andProperties:properties];
    [self.annotationDrawer commitAnnotation:pathAnnotation];
    [pathAnnotation release];

}

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Update annotation with spcifiec TAG id
 * RETURN: Void
 --------------------------------------------------------------------------
 */
- (void)annotationUpdateWithID:(NSInteger)inID withUpdatedPoints:(NSDictionary*)pointsDictionary
{
    @synchronized(self)
	{
        DDLogInfo(@"isAnnoPresence:%d,",isAnnotationsPresence);
        if (isAnnotationsPresence == NO || inID == 0) return;//0 id for annoationView
        LAAnnotation *annotationView = (LAAnnotation*) [self viewWithTag:inID];
        DDLogInfo(@"isAnnoExist:%d,",annotationView != nil);
        if (annotationView == nil) return;
        //FIXME parse timestamp and points
        NSTimeInterval timestamp = 0;
        NSMutableArray* points;
        
        ParseDrawingAnnotation(&timestamp, &points);
        
        DDLogInfo(@"update xmpp pos with remote time:%lf,localtime:%lf",timestamp,annotationView.uiTimestamp);
        if(annotationView.uiTimestamp < timestamp)
        {
            annotationView.uiTimestamp = timestamp;
            NSTimeInterval delay = 0.02f;
            [self.trackTimer invalidate];
            self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                               target:self
                                                             selector:@selector(positionAnnotationPoint:)
                                                             userInfo:NSDictionaryOfVariableBindings(points,annotationView)
                                                              repeats:YES];
        }
            
	}
}

-(void)positionAnnotationPoint:(NSTimer*)timer
{
    if (![timer isValid])
    {
        self.trackTimer = nil;
        return;//COVD-389*
    }
    NSDictionary *annotation= [[timer userInfo]retain];
    //KVC access
    NSMutableArray* annotationPoints = annotation[@"points"];
    UIView *inView = annotation[@"annotationView"];
    if (!inView) //this to handle issue COVD-389*
    {
        int count = [annotationPoints count];
        for(int i = count-1;i >= 0; i--)
        {
            [annotationPoints removeObjectAtIndex:i];
        }
        //[xmppAnnotationArray removeObject:inObject];
        [timer invalidate];
        [annotation release];
        self.trackTimer = nil;
        return;
    }
    
    if([annotationPoints count] >0)
    {
        CGPoint pt2 = CGPointFromNumber([annotationPoints objectAtIndex:0]);
        pt2.x *= [LAUtilities getDeviceRatioX];
        pt2.y *= [LAUtilities getDeviceRatioY];
        //            if(inObject.annotationType == eText)
        //            {
        //                //restore center point Text only
        //                pt2.x = pt2.x - 102 + (193/2);
        //                pt2.y -= 165/2;
        //            }
        
        inView.center = pt2;
        [annotationPoints removeObjectAtIndex:0];
        
        if([annotationPoints count] == 0)
        {
            [timer invalidate];
            self.trackTimer = nil;
        }
    }
    else
    {
        [timer invalidate];
        self.trackTimer = nil;
    }
	
    [annotation release];
}


//- (void)loadDrawingAnnotation:(HPPathAnnotation *)inAnnotation
//                      withTag:(NSString*)tag
//{
//    if (_annotationCount == 0) {
//        int inID = [tag intValue];
//        NSLog(@"Annotation check %d",inID % kIpadAnnotationTag);
//        if (inID % kIpadAnnotationTag != 1)
//        {
//                return;
//        }
//    }
//    _annotationCount++;
//    isAnnotationsPresence = YES;
//	[self annotationsNotify];
//	[_drawingView loadDrawingAnnotation:inAnnotation];
//	[self setNeedsDisplay];
//}

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. set timer to queue annotation to be sent
 * RETURN: Void
 --------------------------------------------------------------------------
 */
-(void)setTimerToSendAnnotation
{
    if(self.annotationTimer)
    {
        [self.annotationTimer invalidate];
        self.annotationTimer = nil;
    }
    if(_annotationTool == eDrawing)
    {
        self.annotationTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                                target:self
                                                              selector:@selector(commitOverflowFreeDrawingAnnotation:)
                                                              userInfo:nil repeats:YES];

    }
    else
    {
        self.annotationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
															target:self 
														  selector:@selector(sendPointsToXMPPServer:) 
														  userInfo:nil repeats:YES];
    }
}


-(void)commitOverflowFreeDrawingAnnotation:(NSTimer*) timer
{
    [self.drawingController setDrawingTag:self.tagForFreehand];
    [self.drawingController partialFinishWithView:self.annotationDrawer];
    
}

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Send annotation drawing points to XMPP server.
 * RETURN: Void
 --------------------------------------------------------------------------
 */
-(void)sendPointsToXMPPServer:(NSTimer*)timer 
{
    NSString *str = nil;
    NSInteger count = 0;
    @synchronized(pointArray)
    {
        count = [pointArray count];
        if (count == 0)
        {
            DDLogWarn(@"No annotation points to send");
            return;
        }
        else {
            str = [self createJSONStringFrom:pointArray withOption:nil];
            [pointArray removeAllObjects];
        }
    }
    if (self.selectedAnnotation != nil && str!=nil) {
        [self.delegate sendAnnotation:self.selectedAnnotation withExtra:str];
    }
    
	
}

- (void)installDrawer:(id<HPAnnotationDrawer>) drawer
{
    self.annotationDrawer = drawer;
    [self addSubview:(UIView*)drawer];
    [[self.delegate annotationContainer] sendSubviewToBack:(UIView*)drawer];
}


@end
