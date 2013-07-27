//
//  LABitmapDrawingView.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LABitmapDrawingView.h"

@implementation LABitmapDrawingView
@synthesize annotation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
        self.userInteractionEnabled = NO;
        _dirtyMap = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    return self;
}


-(void)commitAnnotation:(HPAnnotation *)anno
{
    NSNumber *key = [NSNumber numberWithInteger:[anno hash]];
    BOOL isDirty = [[_dirtyMap objectForKey:key] boolValue];
    if(!isDirty && (anno.drawingCapability&eDrawClean) == eDrawClean && _layerRef)
    {
        self.annotation = nil;
        [anno drawWithContext:CGLayerGetContext(_layerRef)isDirty:NO outDirty:NULL];
        [self setNeedsDisplayInRect:anno.bounds];
    }
    [_dirtyMap removeObjectForKey:key];
}

-(void)updateAnnotation:(HPAnnotation *)anno
{
    if((anno.drawingCapability & eDrawDirty) == eDrawDirty && _layerRef)
    {
        CGRect dirtyRect = CGRectZero;
        
        [anno drawWithContext:CGLayerGetContext(_layerRef) isDirty:YES outDirty:&dirtyRect];
        [_dirtyMap setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:[anno hash]]];
        [self setNeedsDisplayInRect:dirtyRect];
    }
    else if((anno.drawingCapability&eDrawClean) == eDrawClean){
        self.annotation = anno;
        [self setNeedsDisplayInRect:anno.bounds];
    }

}

-(void)clearAnnotations
{
    [_dirtyMap removeAllObjects];
    self.annotation = nil;
    if(_layerRef)
    {
        CGContextRef context = CGLayerGetContext(_layerRef);
        CGContextClearRect(context,self.bounds);
     
    }
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
//    NSDate *start = [NSDate date];
   
    
    // Grab the destination context

    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if(!_layerRef)
    {
        _layerRef = CGLayerCreateWithContext(contextRef, self.bounds.size, NULL);
    }
    CGContextSaveGState(contextRef);
    CGContextSetAllowsAntialiasing(contextRef, NO);
    // Composite on the image at the bottom left of the context
//    NSDate *beforeDrawLayer = [NSDate date];
    CGContextDrawLayerInRect(contextRef, self.bounds, _layerRef);
//    NSDate *endDrawLayer = [NSDate date];
    CGContextRestoreGState(contextRef);
//        NSDate *beforeDrawAnno = [NSDate date];
    if(self.annotation)
    {
        [self.annotation drawWithContext:contextRef isDirty:NO outDirty:NULL];
    }
//        NSDate *endDrawAnno = [NSDate date];
//    NSLog(@"Timecost,create layer:%f,draw layer:%f,draw anno:%f",[beforeDrawLayer timeIntervalSince1970] - [start timeIntervalSince1970],[endDrawLayer timeIntervalSince1970]-[beforeDrawLayer timeIntervalSince1970],[endDrawAnno timeIntervalSince1970]-[beforeDrawAnno timeIntervalSince1970]);
}

- (void)dealloc
{
    [_dirtyMap release];
    CGLayerRelease(_layerRef);
    self.annotation = nil;
    [super dealloc];
}

@end
