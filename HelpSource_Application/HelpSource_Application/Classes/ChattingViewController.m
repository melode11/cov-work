//
//  ChattingViewController.m
//  ChatTool
//
//  Created by ThemisKing on 7/22/13.
//  Copyright (c) 2013 ThemisKing. All rights reserved.
//

#import "ChattingViewController.h"
#import "Messaging/Messaging.h"
#import "DataPersist/DataPersist.h"
#import "Utilities/ChatContent.h"
#import "Messaging/TextMessage.h"
#import "CurrentChattingManager.h"
#import "CustomBadge.h"

@interface ChattingViewController ()
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) HPGrowingTextView *textView;
@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, retain) UITableView *chattingListView;
@property (nonatomic,retain) EGORefreshTableHeaderView *refreshMsgHistoryHeaderView;
@property (nonatomic) BOOL isLoadingHistory;
@end

@implementation ChattingViewController
@synthesize  containerView = _containerView;
@synthesize textView = _textView;
@synthesize messages = _messages;
@synthesize chattingListView = _chattingListView;
@synthesize refreshMsgHistoryHeaderView = _refreshMsgHistoryHeaderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)setContact:(BusinessContact *)bc
{
    _contact = [bc retain];
}

- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(resignTextView)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messagingReceiveMessage:)
                                                 name:kSocketServerMsgReceived
                                               object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kSocketServerMsgReceived];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   self.messages = [[CurrentChattingManager sharedInstance] getMessagesWith:_contact.contact.contactId];
    [[CurrentChattingManager sharedInstance] setCurrentUser:_contact.contact.contactId];
//    self.messages = [[NSMutableArray alloc] init];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:_contact.contact.displayName];

    [self addObservers];
    
    if (self.refreshMsgHistoryHeaderView == nil) {
        self.refreshMsgHistoryHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.chattingListView.bounds.size.height, self.chattingListView.frame.size.width, self.chattingListView.bounds.size.height)];
        self.refreshMsgHistoryHeaderView.delegate = self;
        [self.chattingListView addSubview:self.refreshMsgHistoryHeaderView];
    }
    [self.refreshMsgHistoryHeaderView refreshLabelText];
    self.isLoadingHistory = NO;
    
//    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1];
	
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    
	self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	self.textView.minNumberOfLines = 1;
	self.textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	self.textView.returnKeyType = UIReturnKeyGo; //just as an example
	self.textView.font = [UIFont systemFontOfSize:15.0f];
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.placeholder = @"Message";
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:self.containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self.textView.internalTextView setKeyboardType:UIKeyboardTypeDefault];
    [self.textView.internalTextView setReturnKeyType:UIReturnKeyDefault];
    
    // view hierachy
    [self.containerView addSubview:imageView];
    [self.containerView addSubview:self.textView];
    [self.containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(self.containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"Send" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(Send) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[self.containerView addSubview:doneBtn];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

-(void)resignTextView
{
	[self.textView resignFirstResponder];
}

-(void)Send
{
    [self.textView resignFirstResponder];

    if ([self.textView.text isEqualToString:@""]) {
        return;
    }
    ChatContent* textMsg = [[[ChatContent alloc] init] autorelease];
    textMsg.text = self.textView.text;
    textMsg.userId = [NSString stringWithFormat:@"%d",[DAOManager sharedInstance].userProfileDAO.userProfile.userId];
    textMsg.peerId = [NSString stringWithFormat:@"%d",_contact.contact.contactId];
    textMsg.timestamp =[[NSDate date] timeIntervalSince1970];
    [self addToChattingList:textMsg];
    [[Messaging sharedInstance] sendChatMessage:textMsg];
    self.textView.text = @"";
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	self.containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	self.containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.containerView.frame = r;
}

//- (void)addToChattingList:(NSString*) msg withType:(TextMessageType) type{
//	if(![msg isEqualToString:@""])
//	{
//        TextMessage* textMsg = [[TextMessage alloc] init];
//        textMsg.type = type;
//		[self.messages addObject:msg];
//		[self.chattingList reloadData];
//		NSUInteger index = [self.messages count] - 1;
//		[self.chattingList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//	}
//}

- (void)addToChattingList:(ChatContent*) textMsg {
//    [self.messages addObject:textMsg];
    [[CurrentChattingManager sharedInstance] addMessage:textMsg with:_contact.contact.contactId];
    self.messages = [[CurrentChattingManager sharedInstance] getMessagesWith:_contact.contact.contactId];

    [self.chattingListView reloadData];
    NSUInteger index = [self.messages count] - 1;
    [self.chattingListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	UIImageView *balloonView;
	UILabel *label;
    CustomBadge *customBadge5 = nil;;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ChatContent *textMsg = [self.messages objectAtIndex:indexPath.row];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSTimeInterval epoch = [textMsg.timestamp doubleValue]/1000;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:epoch];
    NSString *dateString = [format stringFromDate:date];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
		balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
		balloonView.tag = 1;
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor clearColor];
		label.tag = 2;
		label.numberOfLines = 0;
		label.lineBreakMode = NSLineBreakByWordWrapping;
		label.font = [UIFont systemFontOfSize:14.0];
		
		UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
		message.tag = 0;
		[message addSubview:balloonView];
		[message addSubview:label];
		[cell.contentView addSubview:message];
        
        customBadge5 = [CustomBadge customBadgeWithString:dateString
                                          withStringColor:[UIColor blackColor]
                                           withInsetColor:[UIColor orangeColor]
                                           withBadgeFrame:YES
                                      withBadgeFrameColor:[UIColor blackColor]
                                                withScale:1.0
                                              withShining:YES];
		
		[balloonView release];
		[label release];
		[message release];
	}
	else
	{
        balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
		label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
	}
	
//    ChatContent *textMsg = [self.messages objectAtIndex:indexPath.row];
	NSString *text = textMsg.text;
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:NSLineBreakByWordWrapping];
	
	UIImage *balloon;
    // Messge type: Sent or Received
    if (textMsg.type == eChatIncoming) {
        [customBadge5 setFrame:CGRectMake(self.view.frame.size.width/2-customBadge5.frame.size.width/2, 1.0f, customBadge5.frame.size.width, customBadge5.frame.size.height)];
        balloonView.frame = CGRectMake(320.0f - (size.width + 28.0f), 2.0f + customBadge5.frame.size.height, size.width + 28.0f, size.height + 15.0f);
		balloon = [[UIImage imageNamed:@"MessageBubbleBlue.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:13];
		label.frame = CGRectMake(307.0f - (size.width + 5.0f), 8.0f + customBadge5.frame.size.height, size.width + 5.0f, size.height);
    } else {
        [customBadge5 setFrame:CGRectMake(self.view.frame.size.width/2-customBadge5.frame.size.width/2, 1.0f, customBadge5.frame.size.width, customBadge5.frame.size.height)];
        balloonView.frame = CGRectMake(0.0, 2.0 + customBadge5.frame.size.height, size.width + 28, size.height + 15);
		balloon = [[UIImage imageNamed:@"MessageBubbleGray.png"] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
		label.frame = CGRectMake(16, 8 + customBadge5.frame.size.height, size.width + 5, size.height);
    }

	balloonView.image = balloon;
	label.text = text;
    [cell addSubview:customBadge5];

	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatContent *textMsg = [self.messages objectAtIndex:indexPath.row];
	NSString *body = textMsg.text;
	CGSize size = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0, 480.0) lineBreakMode:NSLineBreakByWordWrapping];
	return size.height + 15 + 25;
}

#pragma mark -
#pragma mark Messaging methods
- (void)messagingReceiveMessage:(NSNotification *)notification {
    Message *msg = notification.object;
    if ([msg.type isEqualToString:TYPE_TEXT]) {
        TextMessage* text = (TextMessage*)msg;
        if (text.content.type == eChatIncoming
            && [text.content.peerId intValue] == _contact.contact.contactId)
            [self addToChattingList:text.content];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.refreshMsgHistoryHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.refreshMsgHistoryHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark  EGORefreshTableHeaderDelegate methods
- (void)requestHistoryDone {
    self.isLoadingHistory = NO;
    [self.refreshMsgHistoryHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.chattingListView];
    [self.refreshMsgHistoryHeaderView refreshLabelText];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    // TODO: refresh if any history record.
    self.isLoadingHistory = YES;
    [self performSelector:@selector(requestHistoryDone) withObject:nil afterDelay:10];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return self.isLoadingHistory;
}

- (NSString*)egoRefreshTableHeaderLabelText:(EGORefreshTableHeaderView*)view {
    // TODO: Set different text label
    return @"Previous messages";
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [[CurrentChattingManager sharedInstance] setCurrentUser:0];
}

- (void)dealloc {
    [_contact release];
    [_chattingListView release];
    [_containerView release];
    [_textView release];
    [super dealloc];
}
@end
