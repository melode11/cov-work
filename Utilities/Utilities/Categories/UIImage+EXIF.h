//
//  UIImage+EXIF.h
//  AuroraPhone
//
//  Created by Yao Melo on 12/21/12.
//
//
#import <UIKit/UIKit.h>
#import "ImageIO/ImageIO.h"

static inline UIImageOrientation UIImageOrientationCombine(UIInterfaceOrientation interfaceOrientation,UIDeviceOrientation deviceOrientation)
{
    //MELO:from DOC,UIInterfaceOrientationLandscapeLeft is equal to UIDeviceOrientationLandscapeRight (and vice versa).
    UIDeviceOrientation devOrentations[4] = {UIDeviceOrientationPortrait,UIDeviceOrientationLandscapeRight,UIDeviceOrientationPortraitUpsideDown,UIDeviceOrientationLandscapeLeft};
    UIInterfaceOrientation intOrientations[4] = {UIInterfaceOrientationPortrait,UIInterfaceOrientationLandscapeLeft,UIInterfaceOrientationPortraitUpsideDown,UIInterfaceOrientationLandscapeRight};
    UIImageOrientation imageOrientations[4] = {UIImageOrientationUp,UIImageOrientationLeft,UIImageOrientationDown,UIImageOrientationRight};
    int devIndex,intIndex;
    for(devIndex = 0;devIndex<4;devIndex++)
    {
        if(deviceOrientation == devOrentations[devIndex])
        {
            break;
        }
    }
    for(intIndex = 0;intIndex<4;intIndex++)
    {
        if(interfaceOrientation == intOrientations[intIndex])
        {
            break;
        }
    }
    //one of orientation didn't match.
    if(devIndex == 4 || intIndex == 4)
    {
        return UIImageOrientationUp;
    }
    else
    {
        int imgIndex = intIndex - devIndex;
        while(imgIndex < 0)
        {
            imgIndex += 4;
        }
        return imageOrientations[imgIndex];
    }
    
}

CFDataRef UIImageCompress(CGImageRef image,CFStringRef representType,CFDictionaryRef options);

CFDictionaryRef UIImageCreateAndExtractProperties(CFDataRef data,CFDictionaryRef requiredKeys,CGImageRef *outputImage);

@interface UIImage (EXIF)

- (NSData*)JPEGRepresentWithQuality:(CGFloat)quality andOrientation:(UIImageOrientation) orientation;

- (NSData*)PNGRepresentWithQuality:(CGFloat)quality andOrientation:(UIImageOrientation) orientation;

- (id)initWithData:(NSData *)data outputOrientation:(UIImageOrientation*) outOrientation;
@end
