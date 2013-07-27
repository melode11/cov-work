//
//  HSPhonebookViewController.h
//  HelpSource_Application
//
//  Created by Yao Melo on 7/18/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessContact.h"
#import "ServerAgents/ServerAgents.h"
#import "EGORefreshTableHeaderView.h"

@interface HSPhonebookViewController : UITableViewController<SADelegate,EGORefreshTableHeaderDelegate>
{
    NSArray* _contactSections;
    
    BOOL _isLoadingContacts;
    
    BusinessContact* _selectContactItem;
}

@property (nonatomic,retain) EGORefreshTableHeaderView *refreshComContactsHeaderView;

@end
