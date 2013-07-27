//
//  HSLoginViewController.h
//  HelpSource_Application
//
//  Created by Yao Melo on 7/17/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerAgents/ServerAgents.h"

@interface HSLoginViewController : UIViewController<SADelegate>

@property (retain, nonatomic) IBOutlet UITextField *textUsername;

@property (retain, nonatomic) IBOutlet UITextField *textPassword;

@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *loadingViews;

@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *errorViews;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activeIndicator;

@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *inputViews;

@property (retain, nonatomic) IBOutlet UILabel *errorLabel;

- (IBAction)onSignIn:(id)sender;

- (IBAction)onTypeDone:(id)sender;

-(void)didAuthentication;
@end
