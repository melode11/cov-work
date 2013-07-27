//
//  LAArrow.m
//  AuroraPhone
//
//  Created by Yao Melo on 11/15/12.
//
//

#import "LAArrow.h"
#import "LAUtilities.h"

@implementation LAArrow

- (id)initWithCenter:(CGPoint) point ifReceived:(BOOL)isRecv
{
    UIImage *arrowImage = [UIImage imageNamed:@"onscreen-annotation-arrow.png"];
    CGSize size = arrowImage.size;
    self = [super initWithFrame:CGRectMake(0, 0, size.width * [LAUtilities getDeviceRatioX] , size.height * [LAUtilities getDeviceRatioY]) isReceived:isRecv];
    if (self) {
        self.center = point;
        _arrowImg = [arrowImage retain];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctxt = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctxt);
    CGContextTranslateCTM(ctxt, 0.0f, rect.size.height);
    CGContextScaleCTM(ctxt, 1.0f, -1.0f);
    CGContextDrawImage(ctxt, rect, [_arrowImg CGImage]);
    CGContextRestoreGState(ctxt);
}

-(AnnotationType)annotationType
{
    return eArrow;
}

-(void)dealloc
{
    [_arrowImg release];
    [super dealloc];
}

@end
