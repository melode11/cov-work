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

#import "NSString+Color.h"



NSString *DRGB			= @"DRGB";
NSString *DCMYK			= @"DCMYK";
NSString *DWhite		= @"DWhite";
NSString *DBlack		= @"DBlack";
NSString *CRGB			= @"CRGB";
NSString *CWhite		= @"CWhite";
NSString *CBlack		= @"CBlack";
NSString *NSNamed		= @"NSNamed";

NSString *NSColorType	= @"NSColor";
NSString *UIColorType	= @"UIColor";


@implementation NSString(Color)

#if !TARGET_OS_IPHONE

+ (NSString *)NSStringFromColor:(NSColor *)inColor
{
	
	NSMutableString *ColorDataString = [ [ NSMutableString alloc] init];;
	[ ColorDataString appendFormat:@"%@ ",NSColorType];  // 1.Color Type
	
	NSString *colorSpaceName		= [inColor colorSpaceName];
	NSString *customColorSpaceName	= nil;
	
	
	NSColor *deviceColor = inColor;
	
	
	if([colorSpaceName isEqualToString:NSDeviceRGBColorSpace])
	{
		customColorSpaceName = DRGB;
	}
	else if([colorSpaceName isEqualToString:NSDeviceCMYKColorSpace])
	{
		customColorSpaceName = DCMYK;
	}
	else if([colorSpaceName isEqualToString:NSCalibratedBlackColorSpace])
	{
		customColorSpaceName = DWhite;
	}
	else
	{
		// Not expected color space. convert to RGB
		DDLogWarn(@"Not expected color space. convert to RGB");
        [LAUtilities showDebuggingMessageTitle:@"Message"
                                      withBody:NSLocalizedString(@"Color object to string conversion, Not expected color space, converting to RGB", @"")];
		deviceColor = [inColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
		customColorSpaceName = DRGB;
	}
	
	
	[ ColorDataString appendFormat:@"%@ ",customColorSpaceName]; // 2. Added ColorSpace Name.
	
	NSInteger count = [deviceColor numberOfComponents];
	
	[ ColorDataString appendFormat:@"%d ",count]; //3. Number Of Components
	
	
	
	CGFloat comps[count];
	[deviceColor getComponents:comps];		//4. Components..
	
	int i;
	for(i = 0 ; i < count ; i++)
	{
		[ ColorDataString appendFormat:@"%f ",comps[i]];
	}
	free(comps);
	return [ ColorDataString autorelease];;
}
#else

+ (NSString *)NSStringFromColor:(UIColor *)inColor
{
	CGColorRef colorRef = [ inColor CGColor];
	NSMutableString *ColorDataString = [ [NSMutableString alloc] init];
	//CGFloat  alphaComponent		= 0.0;
	NSString *colorSpaceName	= nil;
	
	[ColorDataString appendFormat:@"%@ ", UIColorType];  //Color Type
	
	CGColorSpaceRef colorSpace = CGColorGetColorSpace(colorRef);
	if(NULL != colorRef)
	{
		
		//alphaComponent = CGColorGetAlpha(colorRef);
		
		CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpace);
		if(colorSpaceModel == kCGColorSpaceModelRGB)
		{
			colorSpaceName = DRGB;
		}
		else if(colorSpaceModel == kCGColorSpaceModelCMYK)
		{
			colorSpaceName = DCMYK;
		}
		else
		{
			colorSpaceName = DWhite;
		}
		
		[ColorDataString appendFormat:@"%@ ", colorSpaceName]; //Color Space Name
	
		int numComponents = CGColorGetNumberOfComponents(colorRef);  // If the input is color atleast one of the following conditions will hold good
		
		[ColorDataString appendFormat:@"%d ", numComponents]; //Number of Color Components
		
		const CGFloat *components = CGColorGetComponents(colorRef);
		int i;
		for(i = 0 ; i < numComponents ; i++ )
		{
			[ColorDataString appendFormat:@"%f ",components[i] ];
		}
	}
	
	//free(components); 
	return [ ColorDataString autorelease ]; 
}


#endif
/*
+(CGColorRef)colorFromNSString:(NSString *)inString
{
	CGColorRef		colorOutput				= NULL;
	NSArray			*colorStringData	    = nil;
	NSString		*customColorSpaceName   = nil;
	CGColorSpaceRef colorSpace				= NULL;
	
	NSInteger		numberOfComponents		= 0;
	CGFloat			*components				= NULL;
	NSString		*colorType				= NULL;
	
	if(nil != inString)
	{
		colorStringData = [inString componentsSeparatedByString:@" "];
		
		//colorType = [colorStringData objectAtIndex:0];
		
		customColorSpaceName = [ colorStringData objectAtIndex:1];
		
		if([customColorSpaceName isEqualToString:DRGB])
		{
			colorSpace = CGColorSpaceCreateDeviceRGB();
		}
		else if([customColorSpaceName isEqualToString:DCMYK])
		{
			colorSpace = CGColorSpaceCreateDeviceCMYK();
		}
		else if([customColorSpaceName isEqualToString:DWhite])
		{
			colorSpace = CGColorSpaceCreateDeviceGray();
		}
		else
		{
			colorSpace = CGColorSpaceCreateDeviceRGB();
		}
		
		numberOfComponents = [ [ colorStringData objectAtIndex:2] floatValue];
		
		components = malloc(sizeof(CGFloat)*numberOfComponents);
		int i, j;
		for(i = 0, j = 3; i< numberOfComponents ; i++, j++ )
		{
			components[i] = [ [ colorStringData objectAtIndex:j ] floatValue];
		}
		
		
		colorOutput = CGColorCreate(colorSpace , components);
		
		CGColorSpaceRelease(colorSpace);
		free(components);
	}
	// TODO: Not being used anymore. Should we not discard this function altogether?
	return colorOutput;
}
 */
@end
