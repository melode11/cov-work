//
//  LAArrow.h
//  AuroraPhone
//
//  Created by Yao Melo on 11/15/12.
//
//

#import "LAAnnotation.h"

@interface LAArrow : LAAnnotation
{
    UIImage *_arrowImg;
}

- (id)initWithCenter:(CGPoint) point ifReceived:(BOOL)isRecv;

@end
