//
//  UIViewUtils.h
//  AuroraPhone
//
//  Created by Kevin on 1/29/13.
//
//

#import <Foundation/Foundation.h>

@interface UIViewUtils : NSObject

+ (void)dismissActionSheetsSubviews:(NSArray *)subviews finishBlock:(BOOL(^)(UIActionSheet *)) releaseBlock;
+ (void)dismissAlterViewsSubviews:(NSArray *)subviews finishBlock:(BOOL(^)(UIAlertView *)) releaseBlock;

@end
