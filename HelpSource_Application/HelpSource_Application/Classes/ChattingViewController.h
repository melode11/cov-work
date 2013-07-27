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

@interface ChattingViewController : UIViewController <HPGrowingTextViewDelegate>{
	UIView *_containerView;
    HPGrowingTextView *_textView;
    IBOutlet UITableView *_chattingList;
    NSMutableArray *_messages;

    BusinessContact *_contact;
}

-(void)setContact:(BusinessContact*)bc;

@end
