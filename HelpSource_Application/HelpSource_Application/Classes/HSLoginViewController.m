//
//  HSLoginViewController.m
//  HelpSource_Application
//
//  Created by Yao Melo on 7/17/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "HSLoginViewController.h"
#import "DataPersist/DataPersist.h"
#import "Messaging/Messaging.h"

@interface HSLoginViewController ()

- (void)setVisibility:(BOOL)isVisible forViews:(NSArray*) views,...NS_REQUIRES_NIL_TERMINATION;

@end

@implementation HSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignIn:(id)sender {
    NSString* username = _textUsername.text;
    NSString *psw = _textPassword.text;
    if([username length] >= 6 && [psw length] >= 6)
    {
        [[[ServerAgentsFactory sharedInstance] createLoginAgentWithDelegate:self] requestLoginWithName:username password:psw];
        [_activeIndicator startAnimating];
        [self setVisibility:NO forViews:_inputViews,_errorViews, nil];
        [self setVisibility:YES forViews:_loadingViews, nil];
    }
    else
    {
        [self setVisibility:YES forViews:_errorViews, nil];
        _errorLabel.text = @"Please enter valid username and password.";

    }
}

- (IBAction)onTypeDone:(id)sender {
    if(sender == _textUsername)
    {
        [_textPassword becomeFirstResponder];
    }
    else
    {
        [_textPassword resignFirstResponder];
    }
}

-(void)didAuthentication
{
    ServerModel *model = [DAOManager sharedInstance].serverSettingDAO.messagingServerModel;
    UserProfileDAO* upDao = [DAOManager sharedInstance].userProfileDAO;
    [[Messaging sharedInstance] connectToMsgServer:model.host onPort:model.port withToken:upDao.token userID:[NSString stringWithFormat:@"%d",upDao.userProfile.userId]];
    [self performSegueWithIdentifier:@"AuthenticateDone" sender:nil];
}

-(void)transactionFailedWithAgent:(id<ServerAgentProtocol>)agent reason:(SAFailReason)reason andNativeCode:(NSInteger)errCode
{
    [_activeIndicator stopAnimating];
    [self setVisibility:YES forViews:_errorViews,_inputViews, nil];
    [self setVisibility:NO forViews:_loadingViews, nil];
    _errorLabel.text = @"There was an error when signing in with these credentials.";

}

-(void)transactionFinishedWithAgent:(id<ServerAgentProtocol>)agent
{
    if([[agent serviceType] isEqualToString:SERVICE_LOGIN])
    {
        id<SALoginProtocol> loginAgent = (id<SALoginProtocol>)agent;
        [DAOManager sharedInstance].serverSettingDAO.messagingServerModel = [loginAgent messagingServer];
        [[DAOManager sharedInstance].serverSettingDAO store];
        UserProfileDAO* upDao = [DAOManager sharedInstance].userProfileDAO;
        UserProfile *up = [[UserProfile alloc] init];
        up.name = [loginAgent userName];
        up.userId = [loginAgent userId];
        up.displayName = [loginAgent displayName];
        upDao.token = [loginAgent token];
        [upDao store];
        
        [_activeIndicator stopAnimating];
        [self setVisibility:YES forViews:_inputViews, nil];
        [self setVisibility:NO forViews:_errorViews,_loadingViews, nil];
        [self didAuthentication];
    }
}

-(void)setVisibility:(BOOL)isVisible forViews:(NSArray *)views, ...
{
    va_list args;
    va_start(args, views);
    for (NSArray *viewArr = views; viewArr!=nil; viewArr = va_arg(args, NSArray*)) {
        for (UIView* view in viewArr) {
            view.hidden = !isVisible;
        }
    }
    va_end(args);
}


- (void)dealloc {
    [_textUsername release];
    [_textPassword release];
    [_loadingViews release];
    [_activeIndicator release];
    [_errorViews release];
    [_inputViews release];
    [_errorLabel release];
    [super dealloc];
}
@end
