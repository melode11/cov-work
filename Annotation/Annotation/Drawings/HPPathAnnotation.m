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

#import "HPPathAnnotation.h"
#import "LAUtilities.h"
#import "CompatibilityManager.h"
#import "CompatibilityManager+Annotation.h"

static void ConvertCompressedPathApplierFunction ( void* info, const CGPathElement* element )
{
	NSMutableArray *points = (NSMutableArray*)info;
	switch( element->type )
	{
		case kCGPathElementMoveToPoint:
		{
			CGPoint point = CGPointMake( element->points[0].x / [LAUtilities getDeviceRatioX], element->points[0].y / [LAUtilities getDeviceRatioY]);
            [points addObject:NSNumberForPoint(point)];
		}
			break;
			
		case kCGPathElementAddLineToPoint:
		{
			CGPoint point = CGPointMake( element->points[0].x / [LAUtilities getDeviceRatioX], element->points[0].y / [LAUtilities getDeviceRatioY]);
            [points addObject:NSNumberForPoint(point)];
		}
			break;
			
			default:
			break;
	}
}

static void ConvertPathApplierFunction ( void* info, const CGPathElement* element )
{
	NSMutableArray *points = (NSMutableArray*)info;
	switch( element->type )
	{
		case kCGPathElementMoveToPoint:
		{
			CGPoint point = CGPointMake( element->points[0].x / [LAUtilities getDeviceRatioX], element->points[0].y / [LAUtilities getDeviceRatioY]);
            CGSize targetSize = [[CompatibilityManager sharedManager] targetVideoDimension];
            point.x = point.x * targetSize.width/ X_PIX_NORMALIZED;
            point.y = point.y * targetSize.height/Y_PIX_NORMALIZED;
            NSString *pointToValue = NSStringFromCGPoint(point);
            [points addObject:pointToValue];
        }
			break;
			
		case kCGPathElementAddLineToPoint:
		{
			CGPoint point = CGPointMake( element->points[0].x / [LAUtilities getDeviceRatioX], element->points[0].y / [LAUtilities getDeviceRatioY]);
            CGSize targetSize = [[CompatibilityManager sharedManager] targetVideoDimension];
            point.x = point.x * targetSize.width/ X_PIX_NORMALIZED;
            point.y = point.y * targetSize.height/Y_PIX_NORMALIZED;
            NSString *pointToValue = NSStringFromCGPoint(point);
            [points addObject:pointToValue];
		}
			break;
			
        default:
			break;
	}
}

@interface HPPathAnnotation(Private)

- (CGImageRef)createShapeImage;

- (CGContextRef)createBitmapContext;

- (void)disposeBitmapContext:(CGContextRef)bitmapContext;

- (void)stampStart:(CGPoint)startPoint end:(CGPoint)endPoint inContext:(CGContextRef) context;

- (void)stampMask:(CGImageRef)mask at:(CGPoint)point withTool:(HPDrawingTool)inTool inContext:(CGContextRef) context;

- (float)stampMask: (CGImageRef)mask 
			  from: (CGPoint)startPoint
				to: (CGPoint)endPoint
  leftOverDistance: (float)leftOverDistance
		  withTool: (HPDrawingTool)inTool
         inContext: (CGContextRef)context;

- (void)drawPath:(CGPathRef)path tool:(HPDrawingTool)tool inContext:(CGContextRef)context;
@end



@interface HPPathAnnotation(Drawing)
- (void)drawPath:(CGPathRef)path   tool:(HPDrawingTool)tool inContext:(CGContextRef)context;

@end


@implementation HPPathAnnotation(Drawing)

- (void)drawPath:(CGPathRef)path  tool:(HPDrawingTool)tool inContext:(CGContextRef)context 
{
	
	CGContextSaveGState(context);
	
	if (tool == eBrushTool)
	{
        //CGContextSetAllowsAntialiasing(context, NO);
		CGContextSetLineCap(context, kCGLineCapRound);
		CGContextSetLineJoin(context, kCGLineJoinRound);
		CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
		
		CGContextSetAlpha(context, 1.0);
		CGContextSetLineWidth(context, self.strokeWidth);
		CGContextAddPath(context, path);
		CGContextDrawPath(context, kCGPathStroke);
	}
	  
	CGContextRestoreGState(context);
}
@end

@implementation HPPathAnnotation
NSString *const kHPAnnotationPath = @"path";
NSString *const kHPAnnotationCompressedPath = @"path2";
NSString *const kHPAnnotationPathTool = @"tool";
NSString *const kHPAnnotationTransform = @"transform";

@synthesize drawingTool = _drawingTool,transform = _affineTransform;


#pragma mark initialization

-(id)initWithDrawer:(id<HPAnnotationDrawer>)drawer
{
    self = [super initWithDrawer:drawer];
	if( self)
	{
		mRadius =  6.0f;//[ [HPSettings sharedInstance] brushStrokeWidth];
		
		mShape = CGPathCreateMutable();
		CGPathAddEllipseInRect(mShape, nil, CGRectMake(0, 0, mRadius, mRadius));
		mSoftness = 0.9;
        
		mMask = nil;
		mCurrentPoint = mLastPoint = CGPointZero;
		mLeftOverDistance = 0.0;
		self.transform = CGAffineTransformIdentity;
        
	}
	return self;
}

-(void)dealloc
{	
	if(_contents)
	{
		CGPathRelease(_contents);	
	}
	CGPathRelease(mShape);
	CGImageRelease(mMask);
	[super dealloc];
}

///Initialize with properties
-(id)initWithDrawer:(id<HPAnnotationDrawer>)drawer andProperties:(NSDictionary *)inProperties
{
	self = [super initWithDrawer:drawer andProperties:inProperties];
	if(self)
	{
        NSString *pointsStr = [inProperties objectForKey:kHPAnnotationCompressedPath];
        CGFloat ratioX = [LAUtilities getDeviceRatioX];
        CGFloat ratioY = [LAUtilities getDeviceRatioY];
        if(pointsStr)
        {
            NSArray *points = [LAUtilities pointsWithString:pointsStr];
            if([points count]>=2)
            {
                _contents = CGPathCreateMutable();
                mShape = CGPathCreateMutable();
                bool isMove = YES;
                for(NSNumber *point in points)
                {
                    CGPoint cgPoint = CGPointFromNumber(point);
                    if(isMove)
                    {
                        CGPathMoveToPoint(_contents, NULL, cgPoint.x*ratioX, cgPoint.y*ratioY);
                        isMove = NO;
                    }
                    else
                    {
                        CGPathAddLineToPoint(_contents, NULL,cgPoint.x*ratioX,cgPoint.y*ratioY);
                    }

                }
                mShape = CGPathCreateMutable();
                CGPathAddEllipseInRect(mShape, nil, CGRectMake(0, 0, mRadius, mRadius));
                mSoftness = 0.9;
                mMask = nil;
                mCurrentPoint = mLastPoint = CGPointZero;
                mLeftOverDistance = 0.0;
            }
        }
        //keep else routine for backward compatibility
        else
        {
            NSArray *points = [[inProperties objectForKey:kHPAnnotationPath] retain];
            if( [points count] >= 2)
            {
                _contents = CGPathCreateMutable();
                mShape = CGPathCreateMutable();
                NSString *point = [ points objectAtIndex:0];
                CGPoint cgPoint = CGPointFromString(point);
                CGSize targetSize = [[CompatibilityManager sharedManager] targetVideoDimension];
                cgPoint.x = cgPoint.x * X_PIX_NORMALIZED/targetSize.width;
                cgPoint.y = cgPoint.y * Y_PIX_NORMALIZED/targetSize.height;
                CGPathMoveToPoint(_contents, NULL,cgPoint.x*ratioX,cgPoint.y*ratioY);
                for( point in points)
                {
                    CGPoint cgPoint = CGPointFromString(point);
                    cgPoint.x = cgPoint.x * X_PIX_NORMALIZED/targetSize.width;
                    cgPoint.y = cgPoint.y * Y_PIX_NORMALIZED/targetSize.height;
                    CGPathAddLineToPoint(_contents, NULL,cgPoint.x*ratioX,cgPoint.y*ratioY);
                }
                mShape = CGPathCreateMutable();
                CGPathAddEllipseInRect(mShape, nil, CGRectMake(0, 0, mRadius, mRadius));
                mSoftness = 0.9;
                mMask = nil;
                mCurrentPoint = mLastPoint = CGPointZero;
                mLeftOverDistance = 0.0;
            }
            [points release];
		}
		/*********************Retrieve the transform******************************/
		NSString *transformString = [[inProperties objectForKey:kHPAnnotationTransform]retain];
		if( transformString)
		{
			CGAffineTransform transform = [LAUtilities cgaffineTransformFromNSString:transformString];
			self.transform = transform;
		}
		else
		{
			self.transform = CGAffineTransformIdentity; 	
		}
		[transformString release];
		/***********************************************************************/
		self.drawingTool = [(NSNumber *) [inProperties objectForKey:kHPAnnotationPathTool] integerValue];
		
	}
	return self;
}


///get the properties
-(NSMutableDictionary*)properties
{
	NSMutableDictionary *properties = [super properties];
	//Return a dictionary that contain values that can be added to property list
	if( _contents)
	{
		NSMutableArray *points = [[NSMutableArray alloc] init];
        if([[CompatibilityManager sharedManager] isTargetSupportAnnotationCompression])
        {
            CGPathApply(_contents,points , ConvertCompressedPathApplierFunction);
            [properties setObject:[LAUtilities stringWithShiftedPoints:points] forKey:kHPAnnotationCompressedPath];
        }
        else
        {
            CGPathApply(_contents,points , ConvertPathApplierFunction);
            [properties setObject:points forKey:kHPAnnotationPath];
        }
        [points release];
		[properties setObject:[NSNumber numberWithInteger:(NSInteger)self.drawingTool] forKey:kHPAnnotationPathTool]; // Added By Ashish 12/08/09
		NSString *affineTransform = [LAUtilities stringFromCGAffinTransform:self.transform];
		if(affineTransform)
		{
			[properties setObject:affineTransform forKey:kHPAnnotationTransform];	
		} 
	}
	return properties;
}


-(void)drawWithContext:(CGContextRef)context isDirty:(BOOL)isDirty outDirty:(CGRect*) outDirtyRect
{
    
    if( _contents)
	{
		[super drawWithContext:context isDirty:isDirty outDirty:outDirtyRect];
        CGContextSaveGState(context);
        if(isDirty)
        {
            if(CGPointEqualToPoint(mLastPoint, CGPointZero))
            {
//                [self stampMask:mMask at:mCurrentPoint withTool:eBrushTool inContext:context];
//                if(outDirtyRect !=NULL)
//                {
//                    *outDirtyRect = self.bounds;
//                }
            }
            else {
                [self stampStart:mLastPoint end:mCurrentPoint inContext:context];
                
                CGFloat x = (mLastPoint.x < mCurrentPoint.x ?mLastPoint.x : mCurrentPoint.x ) - floor(self.strokeWidth / 2.0);
                CGFloat y = (mLastPoint.y < mCurrentPoint.y ?mLastPoint.y : mCurrentPoint.y) - floor(self.strokeWidth / 2.0);
                
                CGFloat width = fabsf(mLastPoint.x - mCurrentPoint.x)  + floor(self.strokeWidth);
                CGFloat height = fabsf(mLastPoint.y - mCurrentPoint.y)  + floor(self.strokeWidth);
                if(outDirtyRect !=NULL)
                {
                    *outDirtyRect = CGRectMake(x, y, width, height);
                    
                }
            }
        }
        else
        {
            [self drawPath:_contents  tool:self.drawingTool inContext:context];
            if(outDirtyRect !=NULL)
            {
                
                *outDirtyRect = self.bounds;
            }
        }
        //		
		CGContextRestoreGState(context);
	}
    //return displayRect;
}



//Editing
-(void)beginEditing
{
    mLastPoint = CGPointZero;
    mLeftOverDistance = 0.0f;
    if(!mMask)
        mMask = [self createShapeImage];
    
}
-(void)endEditing
{
	if (_contents)
	{
        [self.drawer commitAnnotation:self];
        mLastPoint = CGPointZero;
        mLeftOverDistance = 0.0f;
	}
	
}
- (void) cleanDrawingPath
{
    if (_contents) {
        CGPathRelease(_contents);
        _contents = nil;
    }
    mLastPoint = CGPointZero;
    mLeftOverDistance = 0.0f;
    [[super properties] removeAllObjects];
}
-(void)moveToPoint:(CGPoint)inPoint
{
	if(!_contents)
	{
		_contents = CGPathCreateMutable();
		CGPathMoveToPoint(_contents, NULL, inPoint.x, inPoint.y);
	}
	else
	{
		CGPathAddLineToPoint(_contents, NULL, inPoint.x, inPoint.y);	
	}
    mLastPoint = mCurrentPoint;
    mCurrentPoint = inPoint;
    [self.drawer updateAnnotation:(HPAnnotation*)self];
}

-(void)loadPathAnnotations
{
	//incoming annotations
//	CGContextRef context = UIGraphicsGetCurrentContext();	
//	[HPBitmapDraw sharedBitmap].strokeColor = self.strokeColor;
//	[HPBitmapDraw sharedBitmap].strokeWidth = 6.0f;
//	[ [HPBitmapDraw sharedBitmap] drawPath:_contents tool:self.drawingTool inContext:context];
    [self.drawer commitAnnotation:self];
}

-(void)updateCFTypeContents:(CFTypeRef)inContents
{
   if( inContents)
   {
	   if( CGPathGetTypeID() == CFGetTypeID(inContents))
	   {
		   if( !_contents)
		   {
			   _contents = CGPathCreateMutable();   
		   }
		   CGPathAddPath(_contents, NULL, inContents);
	   }
	   
   }
}

#pragma mark -
#pragma mark New Drawing Methods With Eraser
//- (void)touchBegan:(CGPoint)currentPoint inView:(UIView *)view
//{
//	if(!mMask)
//		mMask = [self createShapeImage];
//	mLastPoint = currentPoint;
//	mLeftOverDistance = 0.0;
//	[[ HPBitmapDraw sharedBitmap] stampMask:mMask at:currentPoint withTool:self.drawingTool]; 	
//}
//- (void)touchMoved:(CGPoint)currentPoint inView:(UIView *)view
//{
//	[self stampStart:mLastPoint end:currentPoint inView:view];
//	mLastPoint = currentPoint;
//}
//
//- (void)touchEnded:(CGPoint)currentPoint inView:(UIView *)view
//{
//	[self stampStart:mLastPoint end:currentPoint inView:view];
//	mLastPoint = CGPointZero;
//	mLeftOverDistance = 0.0;
//}
#pragma mark -
#pragma mark Create Bitmap
#ifndef __clang_analyzer__
- (CGImageRef)createShapeImage
{
	// Create a bitmap context to hold our brush image
	CGContextRef bitmapContext = [self createBitmapContext];
	
	// If we're not going to have a hard edge, set the alpha to 50% (using a
	//	transparency layer)so the brush strokes fade in and out more.
	CGContextBeginTransparencyLayer(bitmapContext, nil);
	// I like a little color in my brushes
	CGContextSetFillColorWithColor(bitmapContext, self.strokeColor.CGColor);
	// The way we acheive "softness" on the edges of the brush is to draw
	//	the shape full size with some transparency, then keep drawing the shape
	//	at smaller sizes with the same transparency level. Thus, the center
	//	builds up and is darker, while edges remain partially transparent.
	
	// First, based on the softness setting, determine the radius of the fully
	//	opaque pixels.
	int innerRadius = (int)ceil(mSoftness * (0.5 - mRadius)+ mRadius);
	int outerRadius = (int)ceil(mRadius);
	int i = 0;
	// The alpha level is always proportial to the difference between the inner, opaque
	//	radius and the outer, transparent radius.
	//float alphaStep = 1.0 / (outerRadius - innerRadius + 1);
	// Since we're drawing shape on top of shape, we only need to set the alpha once
	//CGContextSetAlpha(bitmapContext, alphaStep);
	CGContextSetAlpha(bitmapContext, 1.0); // Changed By Ashish 13/08/09
	for (i = outerRadius; i >= innerRadius; --i)
	{
		CGContextSaveGState(bitmapContext);
		// First, center the shape onto the context.
		CGContextTranslateCTM(bitmapContext, outerRadius - i, outerRadius - i);
		// Second, scale the the brush shape, such that each successive iteration
		//	is two pixels smaller in width and height than the previous iteration.
		float scale = (2.0 * (float)i)/ (2.0 * (float)outerRadius);
		CGContextScaleCTM(bitmapContext, scale, scale);
		// Finally, actually add the path and fill it
		CGContextAddPath(bitmapContext, mShape);
		//CGContextAddPath(bitmapContext, _contents); // Changed By Ashish 13/08/09
		CGContextEOFillPath(bitmapContext);
		CGContextRestoreGState(bitmapContext);
	}
	// We're done drawing, composite the tip onto the context using whatever
	//	alpha we had set up before BeginTransparencyLayer.
	CGContextEndTransparencyLayer(bitmapContext);
	// Create the brush tip image from our bitmap context
	CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
	// Free up the offscreen bitmap
	[self disposeBitmapContext:bitmapContext];
	// Not a leak as the caller would be responsible for calling CGImageRelease(image);
	return image;
}
#endif
//-(void)createShapeForPath:(CGPathRef)inPath
//{
//	CGPathRelease(mShape);
//	mShape = CGPathCreateMutableCopy( inPath);
//}
//
#ifndef __clang_analyzer__
- (CGContextRef)createBitmapContext
{
	
	// Create the offscreen bitmap context that we can draw the brush tip into.
	//	The context should be the size of the shape bounding box.
	CGRect boundingBox = CGPathGetBoundingBox(mShape);
	//CGRect boundingBox = CGPathGetBoundingBox(_contents);  // Changed By Ashish 13/08/09
	size_t width = CGRectGetWidth(boundingBox);
	size_t height = CGRectGetHeight(boundingBox);
	size_t bitsPerComponent = 8;
	size_t bytesPerRow = ((width * 4)+ 0x0000000F)& ~0x0000000F; // 16 byte aligned is good
	size_t dataSize = bytesPerRow * height;
	void* data = calloc(1, dataSize);
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	
	CGContextRef bitmapContext = CGBitmapContextCreate(data, width, height, bitsPerComponent,
													   bytesPerRow, colorspace, 
													   kCGImageAlphaPremultipliedFirst);
	
	CGColorSpaceRelease(colorspace);
	 	
	CGContextClearRect(bitmapContext, CGRectMake(0, 0, width, height));
	// Not a leak as the caller would be responsible. See disposeBitmapContext
	return bitmapContext;
}
#endif
- (void)disposeBitmapContext:(CGContextRef)bitmapContext
{
	void * data = CGBitmapContextGetData(bitmapContext);
	CGContextRelease(bitmapContext);
	free(data);	
}

//#pragma mark -
//#pragma mark Drawing Image
- (void)stampStart:(CGPoint)startPoint end:(CGPoint)endPoint inContext:(CGContextRef)context
{
	float LeftOverDistance = [self stampMask: mMask 
										from: startPoint
										  to: endPoint
							leftOverDistance: mLeftOverDistance
									withTool: self.drawingTool inContext:context];
	
	mLeftOverDistance = LeftOverDistance;
}

- (float)stampMask: (CGImageRef)mask 
			  from: (CGPoint)startPoint
				to: (CGPoint)endPoint
  leftOverDistance: (float)leftOverDistance
		  withTool: (HPDrawingTool)inTool
         inContext: (CGContextRef)context
{
	//Set the spacing between the stamps. By trail and error, I've 
	//determined that 1/10 of the brush width (currently hard coded to 20)
	//is a good interval.
	float spacing = CGImageGetWidth(mask)* 0.1;
	
	// Anything less that half a pixel is overkill and could hurt performance.
	if ( spacing < 0.5 )
		spacing = 0.5;
	
	//Determine the delta of the x and y. This will determine the slope
	//of the line we want to draw.
	float deltaX = endPoint.x - startPoint.x;
	float deltaY = endPoint.y - startPoint.y;
	
	//Normalize the delta vector we just computed, and that becomes our step increment
	//or drawing our line, since the distance of a normalized vector is always 1
	float distance = sqrt( deltaX * deltaX + deltaY * deltaY );
	float stepX = 0.0;
	float stepY = 0.0;
	
	if ( distance > 0.0 )
	{
		float invertDistance = 1.0 / distance;
		stepX = deltaX * invertDistance;
		stepY = deltaY * invertDistance;
	}
	
	float offsetX = 0.0;
	float offsetY = 0.0;
	
	//We're careful to only stamp at the specified interval, so its possible
	//that we have the last part of the previous line left to draw. Be sure
	//to add that into the total distance we have to draw.
	float totalDistance = leftOverDistance + distance;
	
	//While we still have distance to cover, stamp
	while ( totalDistance >= spacing )
	{
		//Increment where we put the stamp
		if ( leftOverDistance > 0 )
		{
			//If we're making up distance we didn't cover the last
			//time we drew a line, take that into account when calculating
			//the offset. mLeftOverDistance is always < spacing.
			offsetX += stepX * (spacing - leftOverDistance);
			offsetY += stepY * (spacing - leftOverDistance);
			
			leftOverDistance -= spacing;
		}
		else
		{
			//The normal case. The offset increment is the normalized vector
			//times the spacing
			offsetX += stepX * spacing;
			offsetY += stepY * spacing;
		}
		
		//Calculate where to put the current stamp at.
		CGPoint stampAt = CGPointMake(startPoint.x + offsetX, startPoint.y + offsetY);
		//Ka-chunk! Draw the image at the current location
		[self stampMask:mMask at:stampAt withTool:eBrushTool inContext:context];
		totalDistance -= spacing;
	}
	//Return the distance that we didn't get to cover when drawing the line.
	//It is going to be less than spacing.
	return totalDistance;	
}

- (void)stampMask:(CGImageRef)mask at:(CGPoint)point withTool:(HPDrawingTool)inTool inContext:(CGContextRef) context
{
    CGContextSaveGState(context);
	// So we can position the image correct, compute where the bottom left
	//	of the image should go, and modify the CTM so that 0, 0 is there.
	CGPoint bottomLeft = CGPointMake( point.x - CGImageGetWidth(mask)* 0.5,
									 point.y - CGImageGetHeight(mask)* 0.5 );
	
	// Now that it's properly lined up, draw the image
	CGRect maskRect = CGRectMake(0, 0, CGImageGetWidth(mask), CGImageGetHeight(mask));
    if(inTool == eBrushTool)
    {
        CGContextTranslateCTM(context, bottomLeft.x, bottomLeft.y);
		CGContextDrawImage(context, maskRect, mask);
	}
	else
	{
        maskRect = CGRectMake(0, 0, CGImageGetWidth(mask) +3, CGImageGetHeight(mask) +3);
        bottomLeft = CGPointMake( point.x - CGImageGetWidth(mask)* 0.7,
                                 point.y - CGImageGetHeight(mask)* 0.7 );
        CGContextTranslateCTM(context, bottomLeft.x, bottomLeft.y);
		CGContextClipToMask(context, maskRect, mask);
		
		CGContextClearRect(context, maskRect);
	}
	
	CGContextRestoreGState(context);
}

-(HPDrawingCapability)drawingCapability
{
    return eDrawDirty|eDrawClean;
}

-(CGRect)bounds
{
    CGFloat strockW = self.strokeWidth;
    CGFloat halfStrockWidth = strockW/2;
    CGRect rect = CGPathGetBoundingBox(_contents);;
    rect.origin.x -= halfStrockWidth;
    rect.origin.y -= halfStrockWidth;
    rect.size.width += strockW;
    rect.size.height += strockW;
    return rect;
}

@end
