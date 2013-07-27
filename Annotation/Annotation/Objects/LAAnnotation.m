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

#import "LAAnnotation.h"
#import "LAUtilities.h"
#import "DeviceProfile.h"
#import "LAStyleManager.h"

@implementation LAAnnotation
@synthesize isReceived,annotationType,annotationColor,uiTimestamp;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
		self.multipleTouchEnabled = NO;
        self.exclusiveTouch = YES;
		if([[DeviceProfile Instance] TypeOfDevice] == IPAD)
		{
			lineWidth = 3.0f * [LAUtilities getAspectRatio];
		}
		else {
			lineWidth = 3.0f;
		}
		
		
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame isReceived:(BOOL)isRecv 
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
		self.multipleTouchEnabled = NO;
        self.exclusiveTouch = YES;
		if([[DeviceProfile Instance] TypeOfDevice] == IPAD)
		{
			lineWidth = 3.0f * [LAUtilities getAspectRatio];
		}
		else {
			lineWidth = 3.0f;
		}
		self.isReceived = isRecv;
		
    }
    return self;
}


-(AnnotationType)annotationType
{
    return eNone;
}

-(UIColor *)annotationColor
{
    return [[LAStyleManager sharedInstance] getColorWithType:self.annotationType isReceived:self.isReceived];
}

-(NSDictionary *)properties
{
    return nil;
}

- (void)dealloc {
    [super dealloc];
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
