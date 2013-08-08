//
//  ChattingViewController.h
//  ChatTool
//
//  Created by ThemisKing on 7/22/13.
//  Copyright (c) 2013 ThemisKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "BusinessContact.h"
#import "EGORefreshTableHeaderView.h"

@interface ChattingViewController : UIViewController <HPGrowingTextViewDelegate, EGORefreshTableHeaderDelegate>{
	UIView *_containerView;
    HPGrowingTextView *_textView;
    IBOutlet UITableView *_chattingListView;
    NSMutableArray *_messages;
    EGORefreshTableHeaderView *refreshMsgHistoryHeaderView;
    
    BusinessContact *_contact;
}

-(void)setContact:(BusinessContact*)bc;

@end
