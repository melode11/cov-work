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

#import "LAUtilities.h"
#import "LACircle.h"
#import "LATextAnnotation.h"
#import "LVConstants.h"
#import "Base64EncoderDecoder.h"
#import "DeviceProfile.h"

 NSString * kSessionServer =        @"SESSIONSERVER_FLAG";
 NSString * kServerAddressKey =		@"UDPSERVERADDRESS";
 NSString * kPortNumberKey =		@"PORTNUMBER";
 NSString * kDebuggingMessagesKey = @"DUBUGGINGMESSAGES";

NSString * kLogVersion = @"LogVersion";

NSString * kLeastBandWidth=			@"LeastBandwidth";
NSString * kVideoBandWidth=			@"VideoBandwidth";
NSString * kLastReceivedbandWidth =	@"LastReceivedBandwidth";

NSString * kServerKey =			@"IP";
NSString * kUsernameKey =		@"Username";
NSString * kPasswordKey =		@"Password";
NSString * kAccountIDKey =		@"AccountID";
NSString * kIsDefaultKey =		@"IsDefault";

static BOOL isDeviceIPad;

@implementation LAUtilities


typedef union _ShiftedPoint
{
    struct
    {
        NSInteger x:16;
        NSInteger y:16;
    } point;
    
    NSInteger integerValue;
    
} ShiftedPoint;

NSNumber* NSNumberForPoint(CGPoint point)
{
    //shift to keep the precision.
    short shiftX = (short)(point.x * 10);
    short shiftY = (short)(point.y * 10);
    ShiftedPoint sp;
    sp.point.x = shiftX;
    sp.point.y = shiftY;
    return [NSNumber numberWithInteger:sp.integerValue];
}

CGPoint CGPointFromNumber(NSNumber* number)
{
    ShiftedPoint sp;
    sp.integerValue = [number integerValue];
    //recover float from the shifted integer.
    return CGPointMake(sp.point.x/10.0f, sp.point.y/10.0f);
}

+(void)initialize
{
    isDeviceIPad = [[DeviceProfile Instance] TypeOfDevice] == IPAD;
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Get class object from the annotation type.
 * RETURN: Name of class 
 --------------------------------------------------------------------------
 */
+ (Class)classForAnnotation:(AnnotationType)inType
{
	Class className = nil;
	switch(inType)
	{
		case eCircle:
			className = [LACircle class];
			break;
		case eText:
			className = [LATextAnnotation class];
			break;
	}
	return className;
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Convert the string to transform
 * RETURN: class object of the CGAffineTransform. 
 --------------------------------------------------------------------------
 */
+ (CGAffineTransform)cgaffineTransformFromNSString:(NSString *)inString
{
	CGAffineTransform transform = CGAffineTransformIdentity;
	if( inString)
	{
		NSMutableString *mutableString = [[NSMutableString alloc] initWithString:inString];
		//remove angular brackets from string
		[mutableString replaceOccurrencesOfString:@"<" withString:@"" options:NSLiteralSearch  range:NSMakeRange(0, [mutableString length])];
		[mutableString replaceOccurrencesOfString:@">" withString:@"" options:NSLiteralSearch  range:NSMakeRange(0, [mutableString length])];
		
		//extracts components of cfaffinetransform
		NSArray *components = [mutableString componentsSeparatedByString:@","];
		//check if it has 6 components
		
		if (6 == [components count])
		{
			transform.a = [[components objectAtIndex:0] floatValue];//component a'
			transform.b = [[components objectAtIndex:1] floatValue];//component b'
			transform.c = [[components objectAtIndex:2] floatValue];//component c'
			transform.d = [[components objectAtIndex:3] floatValue];//component d'
			transform.tx = [[components objectAtIndex:4] floatValue];//component tx'
			transform.ty = [[components objectAtIndex:5] floatValue];// component ty'
 		}
		[mutableString release];
	}
	return transform;
	
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Convert the trasfrom to string
 * RETURN: string. 
 --------------------------------------------------------------------------
 */
+ (NSString *)stringFromCGAffinTransform:(CGAffineTransform)affineTransform
{
    NSString *affineTransformStr = nil;
	affineTransformStr = [NSString stringWithFormat:@"<%f, %f, %f, %f, %f, %f>", affineTransform.a,affineTransform.b,affineTransform.c,affineTransform.d,affineTransform.tx,affineTransform.ty];
	return affineTransformStr;
}
+ (NSString *)getDeviceIPAddress
{
	//InitAddresses();
	//GetIPAddresses();
	//GetHWAddresses();
	
	 
	// int i;
//	 NSString *deviceIP;
//	 for (i=0; i<MAXADDRS; ++i)
//	 {
//	 static unsigned long localHost = 0x7F000001;		// 127.0.0.1
//	 unsigned long theAddr;
//	 
//	 theAddr = ip_addrs[i];
//	 
//	 if (theAddr == 0) break;
//	 if (theAddr == localHost) continue;
//	 
//	 NSLog(@"%s %s %s\n", if_names[i], hw_addrs[i], ip_names[i]);
//	 }
//	 deviceIP = [NSString stringWithFormat:@"%s", ip_names[i]];
//	 
	
	//this will get you the right IP from your device in format like 198.111.222.444. If you use the for loop above you will se that ip_names array will also contain localhost IP 127.0.0.1 that's why I don't use it. Eventualy this was code from mac that's why it uses arrays for ip_names as macs can have multiple IPs
	NSString *ipAddress = [[NSString alloc]initWithFormat:@"%@",@"ip"];//= [[NSString alloc] initWithFormat:@"%s", ip_names[1]];
	return [ipAddress autorelease] ;
	
}

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Get network address from ip address
 * RETURN: NSInterger formate. 
 --------------------------------------------------------------------------
 */
+ (NSInteger)getNumberFromIPAddress:(NSString *)inIPString
{
	const char *  ipAddress = [inIPString UTF8String];
	in_addr_t ipNumber = inet_addr(ipAddress);
	return ipNumber;
	
}

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Get of the text from font
 * RETURN:float. 
 --------------------------------------------------------------------------
 */
+ (float) calculateHeightOfTextFromWidth:(NSString*) text: (UIFont*)withFont: (float)width :(UILineBreakMode)lineBreakMode
{
	[text retain];
	[withFont retain];
	CGSize suggestedSize = [text sizeWithFont:withFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
	
	[text release];
	[withFont release];
	
	return suggestedSize.height;
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Generate binary from the text annotation formate.
 * RETURN: NSData. 
 --------------------------------------------------------------------------
 */
+ (NSData *)getTextAnnotationDataForText:(NSString *)inText withFont:(UIFont *)inFont color:(UIColor *)inColor withTag:(NSInteger)inTag atCenter:(CGPoint)inCenter
{
	NSMutableData *packetData = [[NSMutableData alloc] init];
	
	//Append Tag 
	[packetData appendBytes:&inTag length:sizeof(NSInteger)];
	
	// Append Text data
	NSData *textData = [inText dataUsingEncoding:NSUTF8StringEncoding];
	NSInteger textDataLength = [textData length];
	[packetData appendBytes:&textDataLength length:sizeof(NSInteger)];
	[packetData appendData:textData];
	
	// Append Font data
	NSString *fontName = [inFont fontName];
	NSData *fontNameData = [fontName dataUsingEncoding:NSUTF8StringEncoding];
	NSInteger fontNameLegth = [fontNameData length];
	[packetData appendBytes:&fontNameLegth length:sizeof(NSInteger)];
	[packetData appendData:fontNameData];
	NSInteger fontSize = 20; // FIXME: Do not hard code it!
	[packetData appendBytes:&fontSize length:sizeof(NSInteger)];
	
	// Append Center point
	NSString  * centerPointString =  NSStringFromCGPoint(inCenter);	
	
	NSInteger centerStringLength = [centerPointString length];
	[packetData appendBytes:&centerStringLength length:sizeof(NSInteger)];
	
	[packetData appendData:[centerPointString dataUsingEncoding:NSUTF8StringEncoding]];

	
	// Append Color data 
	// Need to define
	
	return [packetData autorelease];
	
}
/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Get image from the view
 * RETURN: image. 
 --------------------------------------------------------------------------
 */
+ (UIImage *)getImageFromView:(UIView *)inView 
{
    UIGraphicsBeginImageContext(inView.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor clearColor] set];
	CGContextFillRect(ctx, inView.bounds);
    [inView.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. Get aspect retio for the video comming from iPhone
 * RETURN: float-ratio.
 --------------------------------------------------------------------------
 */
+ (float)getAspectRatio
{
    float ratioX = [LAUtilities getDeviceRatioX];
    float ratioY = [LAUtilities getDeviceRatioY];
	float aspect = sqrt(pow(ratioX, 2) + pow(ratioY, 2)) / sqrt (2.0f);
	return aspect;
}

+(CGFloat) getDeviceRatioX
{
    if(isDeviceIPad)
    {
        return X_RATIO_IPAD;
    }
    return X_RATIO_IPHONE;
}

+(CGFloat) getDeviceRatioY
{
    if(isDeviceIPad)
    {
        return Y_RATIO_IPAD;
    }
    return Y_RATIO_IPHONE;
}

+(NSString*) stringWithShiftedPoints:(NSArray*) points
{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:256];
    for(NSObject *obj in points)
    {
        if([obj isKindOfClass:[NSNumber class]])
        {
            NSInteger intVal = [((NSNumber*)obj) integerValue];
            void *bytes = &intVal;
            [data appendBytes:bytes length:sizeof(NSInteger)];
        }
    }
    NSString* base64Str = [data base64EncodedString];
    [data release];
    return base64Str;
}

+(NSArray*) pointsWithString:(NSString*) base64Str
{
    NSData *pointData = [NSData dataFromBase64String:base64Str];
    size_t step = sizeof(NSInteger);
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:20];
    for(int i=0;i<=[pointData length]-step;i+=step)
    {
        NSInteger shiftedVal;
        NSRange range;
        range.location = i;
        range.length = step;
        [pointData getBytes:&shiftedVal range:range];
        [result addObject:[NSNumber numberWithInteger:shiftedVal]];
    }
    return result;
}

@end

