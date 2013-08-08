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
#import "BusinessContactManager.h"

#define MIN_RELOAD_INTERVAL 5.0

@interface HSPhonebookViewController : UITableViewController<SADelegate,EGORefreshTableHeaderDelegate,BusinessContactDelegate, UISearchBarDelegate>
{
    NSArray* _contactSections;
    
    BOOL _isLoadingContacts;
    
    BusinessContact* _selectContactItem;
    
    //for prevent too frequently reloading data.
    NSTimeInterval _lastReloadTime;
    //for prevent too frequently reloading data.
    BOOL _isReloadPosted;
    
    UISearchBar *contactsSearchBar;
    NSMutableArray *searchconlistArray;
    BOOL  searching;

}

@property (nonatomic,retain) EGORefreshTableHeaderView *refreshComContactsHeaderView;
@property (nonatomic, retain) UISearchBar *contactsSearchBar;


@end
