//
//  IndicatorLoadDataView.h
//  
//
//  Created by Wangminqing on 12-6-21.
//  Copyright (c) 2012年 covidien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicatorLoadDataView : UIView
{
    UILabel *nameLabel;
    UIActivityIndicatorView *activeView;
}
- (id)initWithFrame:(CGRect)frame:(NSString *)name;
- (void)changeLabel:(NSString *)name;
@end
