//
//  UIImage+EXIF.m
//  AuroraPhone
//
//  Created by Yao Melo on 12/21/12.
//  Note:
//  Use kCGImagePropertyExifUserComment instead of kCGImagePropertyOrientation
//  Since the Orientation property will effect the Core-Graphics drawing,
//  while we only needs a data carrier here.
//

#import "UIImage+EXIF.h"
#import <MobileCoreServices/UTCoreTypes.h>

//MELO:Macro for __bridge symbol
#ifndef __has_feature
// not LLVM Compiler
#define __has_feature(x) 0
#endif

#if __has_feature(objc_arc)
// compiling with ARC
#define CF_BRIDGE_CAST __bridge
#else
// compiling without ARC
#define CF_BRIDGE_CAST
#endif

CFDataRef UIImageCompress(CGImageRef image,CFStringRef representType,CFDictionaryRef options)
{
    CFMutableDataRef data = CFDataCreateMutable(kCFAllocatorDefault, 0);
//    CFDictionaryRef cfOptions = (CF_BRIDGE_CAST CFDictionaryRef)options;
    CGImageDestinationRef dest = CGImageDestinationCreateWithData(data,representType, 1, NULL);
    CGImageDestinationAddImage(dest, image, options);
    CGImageDestinationFinalize(dest);
    CFRelease(dest);
    return data;
}

CFDictionaryRef UIImageCreateAndExtractProperties(CFDataRef data,CFDictionaryRef requiredKeys,CGImageRef *outputImage)
{
    CGImageSourceRef imageSource =  CGImageSourceCreateWithData(data, NULL);
    CFDictionaryRef properties =  CGImageSourceCopyPropertiesAtIndex(imageSource, 0, requiredKeys);
    *outputImage = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    CFRelease(imageSource);
    return properties;
}

@implementation UIImage (EXIF)

-(NSData *)JPEGRepresentWithQuality:(CGFloat)quality andOrientation:(UIImageOrientation)orientation
{
    CFDataRef data = UIImageCompress([self CGImage], kUTTypeJPEG, ((CF_BRIDGE_CAST CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:quality],kCGImageDestinationLossyCompressionQuality,[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",orientation],kCGImagePropertyExifUserComment, nil],kCGImagePropertyExifDictionary, nil]));
    return [((CF_BRIDGE_CAST NSData*)CFMakeCollectable(data)) autorelease];
}

-(NSData *)PNGRepresentWithQuality:(CGFloat)quality andOrientation:(UIImageOrientation)orientation
{
    CFDataRef data = UIImageCompress([self CGImage], kUTTypePNG, ((CF_BRIDGE_CAST CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:quality],kCGImageDestinationLossyCompressionQuality,[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",orientation],kCGImagePropertyExifUserComment, nil],kCGImagePropertyExifDictionary, nil]));
    return [((CF_BRIDGE_CAST NSData*)CFMakeCollectable(data)) autorelease];
}

-(id)initWithData:(NSData *)data outputOrientation:(UIImageOrientation *)outOrientation
{
    //release allocated.
    CGImageRef image;
    CFDictionaryRef properties = UIImageCreateAndExtractProperties((CF_BRIDGE_CAST CFDataRef)data, NULL, &image);
    if(properties)
    {
        CFDictionaryRef exif =  CFDictionaryGetValue(properties, kCGImagePropertyExifDictionary);
        if(exif)
        {
            CFStringRef orientation = CFDictionaryGetValue(exif, kCGImagePropertyExifUserComment);
            if(orientation)
            {
                *outOrientation = CFStringGetIntValue(orientation);
            }
        }
        CFRelease(properties);
    }
    if(image)
    {
        self = [self initWithCGImage:image];
        CGImageRelease(image);
    }
    return self;
}
@end
