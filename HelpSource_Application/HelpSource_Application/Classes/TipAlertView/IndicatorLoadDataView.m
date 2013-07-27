//
//  IndicatorLoadDataView.m
//  
//
//  Created by wangminqing on 12-6-21.
//  Copyright (c) 2012年 covidien. All rights reserved.
//

#import "IndicatorLoadDataView.h"

@implementation IndicatorLoadDataView

- (id)initWithFrame:(CGRect)frame:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView *indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(104, 163+47, 112, 112)];
        [indicatorView setImage:[UIImage imageNamed:@"Sign_in_Loading_bg_.png"]];
		[self addSubview:indicatorView];
        
		activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activeView.frame = CGRectMake(39, 20, 34, 34);
		[indicatorView addSubview:activeView];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(6,65, 100, 35)];
        nameLabel.font = [UIFont boldSystemFontOfSize:15];
        nameLabel.numberOfLines = 0 ;
        nameLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor=[UIColor whiteColor];
        [nameLabel setTextAlignment:UITextAlignmentCenter];
        nameLabel.text = name;
        [indicatorView addSubview:nameLabel];
        
        [activeView startAnimating];
        [indicatorView release];
    }
    return self;
}

- (void)changeLabel:(NSString *)name
{
    [activeView stopAnimating];
    activeView.hidden = YES;
    [nameLabel setFrame:CGRectMake(6, 36, 100, 36)];
    nameLabel.text = name;
}

- (void)dealloc
{
    [activeView release];
    [nameLabel release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
