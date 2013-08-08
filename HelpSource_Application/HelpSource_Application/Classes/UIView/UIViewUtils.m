//
//  UIViewUtils.m
//  AuroraPhone
//
//  Created by Kevin on 1/29/13.
//
//

#import "UIViewUtils.h"

@implementation UIViewUtils

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. dismiss UIAtionSheet by recursion view's subview
 2. when releaseBlock is not null, it will excute finishBlock after dismiss UIAtionSheet
 * RETURN: void
 --------------------------------------------------------------------------
 */
+ (void)dismissActionSheetsSubviews:(NSArray *)subviews finishBlock:(BOOL(^)(UIActionSheet *)) releaseBlock
{
    if(!subviews || [subviews count] == 0)
        return;
    Class ASClass = [UIActionSheet class];
    for (UIView * subview in subviews){
        if ([subview isKindOfClass:ASClass]){
            [(UIActionSheet *)subview dismissWithClickedButtonIndex:[(UIActionSheet *)subview cancelButtonIndex] animated:NO];
            if(releaseBlock){
                releaseBlock((UIActionSheet *)subviews);
            }
            
        } else {
            [self dismissActionSheetsSubviews:subview.subviews finishBlock:releaseBlock];
        }
    }
}

/**
 --------------------------------------------------------------------------
 * RESPONSIBILITY:
 1. dismiss AlterView by recursion view's subview
 2. when releaseBlock is not null, it will excute finishBlock after dismiss UIAtionSheet
 * RETURN: void
 --------------------------------------------------------------------------
 */
+ (void)dismissAlterViewsSubviews:(NSArray *)subviews finishBlock:(BOOL(^)(UIAlertView *)) releaseBlock {
    if(!subviews || [subviews count] == 0)
        return;
    Class AVClass = [UIAlertView class];
    for (UIView * subview in subviews){
        if ([subview isKindOfClass:AVClass]){
            [(UIAlertView *)subview dismissWithClickedButtonIndex:[(UIActionSheet *)subview cancelButtonIndex] animated:NO];
            if(releaseBlock){
                releaseBlock((UIAlertView *)subviews);
            }
            
        } else {
            [self dismissAlterViewsSubviews:subview.subviews finishBlock:releaseBlock];
        }
    }
}

@end
