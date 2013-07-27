//
//  TipAlertView.h
//  HelpSource
//
//  Created by WangMinqing on 12-9-19.
//  Copyright (c) 2012年 covidien. All rights reserved.
//
#import "TipAlertView.h"


@implementation TipAlertView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithContent:(NSString*)content
{
    self = [super init];
    if (self) {
        tipContent = [content retain];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissAnimated:) userInfo:nil repeats:NO];
       
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    for (UIView *v in [self subviews]) {
        if ([v class] == [UIImageView class]){
            [v setHidden:YES];
        }
        
        
        if ([v isKindOfClass:[UIButton class]] ||
            [v isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            [v setHidden:YES];
        }
    }
    
    UIImage *backgroundImage = [UIImage imageNamed:@"Sign_in_Loading_bg_.png"];
    UIImageView *contentview = [[UIImageView alloc] initWithImage:backgroundImage];
    contentview.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    [self addSubview:contentview];
    [contentview release];
    self.bounds = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    
    UILabel *promtText = [[UILabel alloc]initWithFrame:CGRectMake(4, 10, backgroundImage.size.width-8, 90)];
    promtText.text = tipContent;
    promtText.textColor = [UIColor whiteColor];
    promtText.numberOfLines = 0;
    promtText.lineBreakMode = UILineBreakModeWordWrap;
    [promtText setFont:[UIFont systemFontOfSize:15]];
    promtText.textAlignment = UITextAlignmentCenter;
    promtText.backgroundColor = [UIColor clearColor];
    [self addSubview:promtText];
    [promtText release];
}

- (void)drawRect:(CGRect)rect {
	UIImage *backgroundImage = [UIImage imageNamed:@"Sign_in_Loading_bg_.png"];
	[backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
}

- (void) dismissAnimated:(id)sender
{
    [self dismissWithClickedButtonIndex:0 animated:NO];
    [self removeFromSuperview];
    [delegate hideTipAlertView:self.tag];
    [timer isValid];
    timer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) dealloc
{
    [super dealloc];
}
@end
