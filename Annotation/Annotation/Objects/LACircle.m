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

#import "LACircle.h"
#import "DeviceProfile.h"

@implementation LACircle


- (id)initWithFrame:(CGRect)inFrame withRadius:(NSInteger)inRadius
{
	if(self = [super initWithFrame:inFrame])
	{
		_radius = inRadius;
		
	}
	return self;
}

- (id)initWithFrame:(CGRect)inFrame withRadius:(NSInteger)inRadius ifSelf:(BOOL)changeColor
{
	if(self = [super initWithFrame:inFrame isReceived:changeColor])
	{
		_radius = inRadius;
	}
	return self;
	
}

//-(void)drawInContext:(CGContextRef)context
//{
//    CGContextSetStrokeColorWithColor(context, self.annotationColor.CGColor);
//	// Draw them with a 2.0 stroke width so they are a bit more visible.
//    CGContextSetLineWidth(context, lineWidth);
//	
//	// Add an ellipse circumscribed in the given rect to the current path, then stroke it
//	CGContextAddEllipseInRect(context, CGRectMake(lineWidth, lineWidth, (_radius * 2.0f) - (lineWidth * 2) , (_radius * 2.0f) - (lineWidth * 2)));
//	CGContextStrokePath(context);
//	
//}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.annotationColor.CGColor);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, lineWidth);
	
	// Add an ellipse circumscribed in the given rect to the current path, then stroke it
	CGContextAddEllipseInRect(context, CGRectMake(lineWidth, lineWidth, (_radius * 2.0f) - (lineWidth * 2) , (_radius * 2.0f) - (lineWidth * 2)));
	CGContextStrokePath(context);
}

-(AnnotationType)annotationType
{
    return eCircle;
}


#pragma mark -
#pragma mark Touch Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
}

@end
