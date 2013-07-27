//
//  LABitmapDrawingView.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPAnnotation.h"

@interface LABitmapDrawingView : UIView<HPAnnotationDrawer>
{
    @private
//    BOOL _isDirtyDraw;
    CGLayerRef _layerRef;
    NSMutableDictionary *_dirtyMap;
}

@property (retain,nonatomic) HPAnnotation* annotation;
@end
