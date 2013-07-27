//
//  TipAlertView.h
//  HelpSource
//
//  Created by WangMinqing on 12-9-19.
//  Copyright (c) 2012年 covidien. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TipAlertViewDelegate <NSObject>
@optional
- (void) hideTipAlertView:(int)tag;
@end

@interface TipAlertView : UIAlertView
{
    NSTimer *timer;
    NSString *tipContent;
    id<TipAlertViewDelegate> delegate; 
}

@property (nonatomic,assign) id<TipAlertViewDelegate> delegate; 
- (id)initWithContent:(NSString*)content;
@end
