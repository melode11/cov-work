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

#import "HPAnnotation.h"
#import "NSString+Color.h"

#import "LAStyleManager.h"
#import "LAUtilities.h"
//#import "HPUBrushSelect.h"
//#import "HPSettings.h"
//Properties of this graphic class
NSString * const kHPAnnotationStrokeColor =@"strokecolor";
NSString *const kHPAnnotationFillColor = @"fillcolor";
NSString *const kHPAnnotationIsEditable = @"isEditable";
NSString *const kHPAnnotationBounds = @"bounds";
NSString *const kHPAnnotationStrokeWidth = @"strokewidth";


NSString *const kHPAnnotationContentsUpdated = @"contentsUpdated";

@implementation HPAnnotation
@synthesize isEditable, bounds=_bounds,strokeWidth=_strokeWidth,isReceived=_isReceived,drawer=_drawer,drawingCapability,strokeColor,fillColor,tag;

#pragma mark initialization
///initialization
//-(id)init
//{
//	self = [super init];
//	if( self)
//	{
//		//Added by Hank
//		//if([[DeviceProfile Instance] TypeOfDevice] == IPAD)
//        
//        self.strokeWidth = 6.0f;
//	}
//	return self;
//}

-(void)dealloc
{
    self.drawer=nil;
    [super dealloc];
}

///nitialize with properties
//-(id)initWithProperties:(NSDictionary*)inProperties
//{
//	self = [super init];
//	if(self)
//	{
///*
//		CGColorRef strokeColorCG = [NSString colorFromNSString:(NSString*) [ inProperties objectForKey:kHPAnnotationStrokeColor]];
//		UIColor * strokeColor = (strokeColorCG == NULL) ? nil :[UIColor colorWithCGColor:strokeColorCG];
//		
//		self.strokeColor = strokeColor;
//		
//		CGColorRef fillColorCG = [NSString colorFromNSString:(NSString*) [ inProperties objectForKey:kHPAnnotationFillColor]];
//		UIColor * fillColor = (fillColorCG == NULL) ? nil :[UIColor colorWithCGColor:fillColorCG];
//		
// 		self.fillColor = fillColor;
//		self.strokeWidth = [[ inProperties objectForKey:kHPAnnotationStrokeWidth] floatValue];
//		self.isEditable = [[inProperties objectForKey:kHPAnnotationIsEditable] boolValue];
//		self.bounds = CGRectFromString([inProperties objectForKey:kHPAnnotationBounds]);
// */
//	}
//	return self;
//}

-(id)initWithDrawer:(id<HPAnnotationDrawer>)drawer
{
    self = [super init];
    if(self)
    {
        self.drawer = drawer;
        _isReceived = NO;
        self.strokeWidth = 6.0f;
    }
    return self;
}

-(id)initWithDrawer:(id<HPAnnotationDrawer>)drawer andProperties:(NSDictionary *)inProperties
{
    self = [super init];
    if(self)
    {
        self.drawer = drawer;
        //Must be received if init by properties.
        _isReceived = YES;
        CGFloat ratio = [LAUtilities getAspectRatio];
        self.strokeWidth = [[ inProperties objectForKey:kHPAnnotationStrokeWidth] floatValue] * ratio;
        self.isEditable = [[inProperties objectForKey:kHPAnnotationIsEditable] boolValue];
        self.bounds = CGRectFromString([inProperties objectForKey:kHPAnnotationBounds]);
        _bounds.size.width *= ratio;
        _bounds.size.height*= ratio;
    }
    return self;
}


-(void)drawWithContext:(CGContextRef)context isDirty:(BOOL)isDirty outDirty:(CGRect *)outDirtyRect
{
   
}

-(UIColor *)strokeColor
{
    return [[LAStyleManager sharedInstance] getColorWithType:eDrawing isReceived:self.isReceived];
}
-(UIColor *)fillColor
{
    return [[LAStyleManager sharedInstance] getColorWithType:eDrawing isReceived:self.isReceived];
}

///get the properties
-(NSMutableDictionary*)properties
{
	//Return a dictionary that contain values that can be added to property list
	NSMutableDictionary *properties = [ NSMutableDictionary dictionary];
	[properties setObject:NSStringFromCGRect(self.bounds) forKey:kHPAnnotationBounds];
	//still put the color in properties for complaint with old client.
    NSString *strokeColorStr = [NSString NSStringFromColor:self.strokeColor];
    if( strokeColorStr)
    {
        [properties setObject:strokeColorStr forKey:kHPAnnotationStrokeColor];
    }
	
    NSString *fillColorStr = [NSString NSStringFromColor:self.fillColor];
    if( fillColorStr)
    {
        [properties setObject:fillColorStr forKey:kHPAnnotationFillColor];
    }
	
	[properties setObject:[NSNumber numberWithBool:isEditable] forKey:kHPAnnotationIsEditable];
	[properties setObject:[NSNumber numberWithFloat:_strokeWidth] forKey:kHPAnnotationStrokeWidth];
    return properties;
}

-(UIImage *)thumbnailImage
{
	return nil;	
}

-(NSString *)resourcePath
{
	return nil;	
}

-(void)updateContents:(id)inContents
{
   //override to update the contents like text, image	
}

-(void)updateCFTypeContents:(CFTypeRef)inContents
{
	
}


//#pragma mark Drawing
//-(void)drawInRect:(CGRect)inRect
//{
//	[self.strokeColor set];
//	[self.fillColor set];
//	CGContextRef context = UIGraphicsGetCurrentContext();
////	CGContextSetStrokeColorWithColor(context, [_strokeColor CGColor]);
////	CGContextSetFillColorWithColor(context, [_fillColor CGColor]);
//	CGContextSetLineWidth( context, _strokeWidth);
//}

	 
#pragma mark Event Handling
-(void)moveToPoint:(CGPoint)inPoint
{
		
}


//Editing
-(void)beginEditing
{
	
}


-(void)endEditing
{
	
}
#pragma mark -
-(void)loadPathAnnotations
{
	// Override to load Path annotations
}
	 


-(HPDrawingCapability)drawingCapability
{
    return eDrawNone;
}

-(NSInteger)tag
{
    return 0;
}

-(AnnotationType)annotationType
{
    return eDrawing;
}

@end
