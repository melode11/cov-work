//
//  HSPhonebookViewController.m
//  HelpSource_Application
//
//  Created by Yao Melo on 7/18/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "HSPhonebookViewController.h"
#import "ServerAgents/ServerAgents.h"
#import "Utilities/NSString+Name_Device.h"
#import "BusinessContactManager.h"
#import "DataPersist/DataPersist.h"
#import "CurrentChattingManager.h"
#import "Messaging/Messaging.h"
#import "Messaging/TextMessage.h"
#import "CustomBadge.h"

#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"

@interface HSPhonebookViewController ()

-(void)groupingWrappedContacts:(NSArray*) wrapped to:(NSMutableArray*)output;

-(void)reloadContacts;

-(void)reloadContactsImmediately;

@end

@implementation HSPhonebookViewController

@synthesize contactsSearchBar;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
//        Contact *A = [[Contact alloc] init];
//        A.name = @"melo.yao";
//        A.displayName = @"Melo Yao";
//
//        Contact *B = [[Contact alloc] init];
//        B.name = @"tony.chen";
//        B.displayName = @"Tony Chen";
//
//        Contact *C = [[Contact alloc] init];
//        C.name = @"themis.king";
//        C.displayName = @"Themis King";
//
//        NSArray* conArr = [[NSArray alloc] initWithObjects:A,B,C,nil];
//        [A release];
//        [B release];
//        [C release];
//        srand((unsigned int) time(NULL));
//        //use a new array for sorting.
//        NSMutableArray *wrapped = [[NSMutableArray alloc] initWithCapacity:[conArr count]];
//        
//        NSMutableArray *sections =[[NSMutableArray alloc] initWithCapacity:27];
//        [self groupingWrappedContacts:wrapped to:sections];
//        [conArr release];
//        [wrapped release];
//        _contactSections = sections;

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    _selectContactItem.contact.missedMsgCount = 0;
    [super viewWillAppear:YES];
}

-(void)groupingWrappedContacts:(NSArray *)wrapped to:(NSMutableArray *)output
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    unichar firstLetter = [[wrapped objectAtIndex:0] groupTag];
    for (BusinessContact* contact in wrapped) {
        
        unichar letter = [contact groupTag];
        if(firstLetter!= letter)
        {
            firstLetter = letter;
            [output addObject:items];
            [items release];
            items = [[NSMutableArray alloc] init];
        }
        [items addObject:contact];
    }
    if([items count]>0)
    {
        [output addObject:items];
    }
    [items release];
}

- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageReceived:)
                                                 name:kSocketServerMsgReceived
                                               object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kSocketServerMsgReceived];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[CurrentChattingManager sharedInstance] setCurrentUser:0];
    
    searchconlistArray  = [[NSMutableArray alloc]init];
    searching = NO;
    contactsSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self addObservers];
    contactsSearchBar.delegate = self;
    self.tableView.tableHeaderView = contactsSearchBar;
    
    if (_refreshComContactsHeaderView == nil) {
        _refreshComContactsHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
        _refreshComContactsHeaderView.delegate = self;
        [self.tableView addSubview:_refreshComContactsHeaderView];
    }
    
    [_refreshComContactsHeaderView refreshLastUpdatedDate];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[[ServerAgentsFactory sharedInstance] createUserListAgentWithDelegate:self]requestUserListWithToken:[DAOManager sharedInstance].userProfileDAO.token];
    _isLoadingContacts = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)transactionFailedWithAgent:(id<ServerAgentProtocol>)agent reason:(SAFailReason)reason andNativeCode:(NSInteger)errCode
{
    [self doneLoadingTableViewData];
}

-(void)transactionFinishedWithAgent:(id<ServerAgentProtocol>)agent
{
    if([[agent serviceType] isEqualToString:SERVICE_USERLIST])
    {
        id<SAUserListProtocol> slAgent = (id<SAUserListProtocol>) agent;
        [[BusinessContactManager sharedInstance] setContacts:[slAgent contacts]];
        [[BusinessContactManager sharedInstance] updateStatus:[slAgent statusMapping] devices:[slAgent activeDevicesMapping]];
        [[BusinessContactManager sharedInstance] setDelegate:self];
        NSArray* contacts = [[BusinessContactManager sharedInstance] businessContactsInAlphabeticOrder];
        NSMutableArray *sections =[[NSMutableArray alloc] initWithCapacity:27];
        [self groupingWrappedContacts:contacts to:sections];
        _contactSections = sections;
        [self reloadContactsImmediately];
        [self doneLoadingTableViewData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (searching) {
        return 1;
    }
    
    // Return the number of sections.
    return [_contactSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searching) {
        return [searchconlistArray count];
    }
    // Return the number of rows in the section.
    return [[_contactSections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    BusinessContact *c = nil;
    if (searching) {
        c = [searchconlistArray objectAtIndex:indexPath.row];
    }else{
        c = [[_contactSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = c.contact.displayName;
    BOOL isOnline = c.isMessagingOnline;
    cell.imageView.image = [UIImage imageNamed:isOnline? @"portait-online.png":@"portait.png"];
    
    CustomBadge *customBadge1 = nil;
    [customBadge1 setFrame:CGRectMake(cell.imageView.frame.size.width+customBadge1.frame.size.width, 0, customBadge1.frame.size.width, customBadge1.frame.size.height)];
    
    if (c.contact.missedMsgCount > 0) {
        customBadge1 = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", c.contact.missedMsgCount]
                                          withStringColor:[UIColor whiteColor]
                                           withInsetColor:[UIColor redColor]
                                           withBadgeFrame:YES
                                      withBadgeFrameColor:[UIColor whiteColor]
                                                withScale:0.7
                                              withShining:YES];
        [cell.imageView addSubview: customBadge1];
        [cell.imageView bringSubviewToFront:customBadge1];
    } else {
        for (UIView* view in [cell.imageView subviews]) {
            if ([view isKindOfClass:[CustomBadge class]]) {
                [view removeFromSuperview];
            }
        }
    }
    cell.detailTextLabel.text = isOnline? @"Chat":@"Notify";
    cell.detailTextLabel.textColor = isOnline?[UIColor greenColor] : [UIColor grayColor];
    // Configure the cell...

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)reloadTableViewDataSource{
    if(!_isLoadingContacts)
    {
        _isLoadingContacts= YES;
        [[[ServerAgentsFactory sharedInstance] createUserListAgentWithDelegate:self]requestUserListWithToken:[DAOManager sharedInstance].userProfileDAO.token];
    }
    
}

- (void)doneLoadingTableViewData{
    _isLoadingContacts = NO;
    [_refreshComContactsHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    [contactsSearchBar resignFirstResponder];
    [_refreshComContactsHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
    [_refreshComContactsHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{

	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
    return _isLoadingContacts;
    
    // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [contactsSearchBar resignFirstResponder];
    [self enableSearchBarCancelButton];
    NSArray *subViews = [[self.tableView cellForRowAtIndexPath:indexPath].imageView subviews];
    for (UIView *v in subViews) {
        [v removeFromSuperview];
    }

    BusinessContact *c = nil;
    if (searching) {
        c = [[searchconlistArray objectAtIndex:indexPath.row] retain];
    }else{
        c = [[[_contactSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] retain];
    }
    // Navigation logic may go here. Create and push another view controller.
    c.contact.missedMsgCount = 0;
    _selectContactItem = c;
//    _selectContactItem =  [[[_contactSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] retain];
    [self performSegueWithIdentifier:@"Chatting" sender:nil];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
//    return index;
    unichar tag = [title characterAtIndex:0];
    if(tag == '#')
    {
        return [_contactSections count]-1;
    }
    NSInteger i = 0;
    for (; i<[_contactSections count]; ++i) {
        if([[[_contactSections objectAtIndex:i]objectAtIndex:0] groupTag] >= tag)
        {
            return i;
        }
    }
    return i - 1;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (searching) {
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
//    for(NSArray* section in _contactSections)
//    {
//        ContactItem* item = [section objectAtIndex:0];
//        unichar tag = [item groupTag];
//        [arr addObject:[NSString stringWithCharacters:&tag length:1]];
//    }
    for (NSInteger i = 0 ; i<[ALPHA length]; ++i) {
        NSRange range;
        range.location = i;
        range.length = 1;
        [arr addObject:[ALPHA substringWithRange:range]];
    }
    return arr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (searching) {
        return 0;
    }
    return 28;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (searching) {
        return nil;
    }
	UIImageView* headerView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alphabet-divider-bar.png"]] autorelease];
	UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]; // #878787
	headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
	headerLabel.frame = CGRectMake(13.0, 0.0, 50.0, 28.0);
    unichar title = [[[_contactSections objectAtIndex:section] objectAtIndex:0] groupTag];
	headerLabel.text = [NSString stringWithFormat:@"%@", [NSString stringWithCharacters:&title length:1]];
	[headerView addSubview:headerLabel];
    
	return headerView;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Chatting"])
    {
        if([segue.destinationViewController respondsToSelector:@selector(setContact:)])
        {
            [segue.destinationViewController performSelector:@selector(setContact:) withObject:_selectContactItem];
        }
    }
}

-(void)contactStatusDidChange:(BusinessContact *)changedContact
{
    [self reloadContacts];
}

-(void)reloadContacts
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if(!_isReloadPosted)
    {
        if(now - _lastReloadTime >= MIN_RELOAD_INTERVAL || now < _lastReloadTime)
        {
            [self.tableView reloadData];
            _lastReloadTime = now;
        }
        else
        {
            
            [self performSelector:@selector(reloadContactsImmediately) withObject:nil afterDelay:(MIN_RELOAD_INTERVAL+(_lastReloadTime - now))];
            _isReloadPosted = YES;
        }
    }

}

-(void)reloadContactsImmediately
{
    [self.tableView reloadData];
    _lastReloadTime = [[NSDate date] timeIntervalSince1970];
    _isReloadPosted = NO;
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    UIImageView *upTableViewBg = (UIImageView*)[self.view viewWithTag:10001];
    upTableViewBg.hidden=NO;
    [self.view bringSubviewToFront:upTableViewBg];
    contactsSearchBar.showsCancelButton = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    searching = YES;
    
    for (UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:[UIButton class]]){
            [(UIButton *)subView setTintColor:self.navigationController.navigationBar.tintColor];
        }
    }
    
    [self.tableView reloadSectionIndexTitles];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //reset data
    [self resetSearch];
    searchBar.text = @"";
    searching = NO;
    [self.tableView reloadData];
    
    [contactsSearchBar resignFirstResponder];
    contactsSearchBar.showsCancelButton = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    searchTerm = [searchTerm uppercaseString];
    int i = 0;
    int count = searchconlistArray.count;

    for(i = count - 1; i >= 0; i--)
    {
        BusinessContact *c = [searchconlistArray objectAtIndex:i];
        NSRange searchRange = [[c.contact.displayName uppercaseString] rangeOfString:[searchTerm uppercaseString]];
        if(searchRange.location != NSNotFound)
        {
            continue;
        }
        [searchconlistArray removeObjectAtIndex:i];
    }
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm  {
    [self resetSearch];
    if ([searchTerm length] == 0)
    {
        //        searching = NO;
        [self.tableView reloadData];
        return;
    }
    searching = YES;
    [self handleSearchForTerm:searchTerm];
    return;
}

- (void)enableSearchBarCancelButton
{
    for(id cc in [contactsSearchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            btn.enabled = YES;
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    UIImageView *upTableViewBg = (UIImageView*)[self.view viewWithTag:10001];
    upTableViewBg.hidden=YES;
    [self enableSearchBarCancelButton];
}

-(void)resetSearch{
    NSArray* contacts = [[BusinessContactManager sharedInstance] businessContactsInAlphabeticOrder];
    searchconlistArray = [[NSMutableArray alloc]initWithArray:contacts];
}

- (void)dealloc
{
    [_refreshComContactsHeaderView release];
    [_contactSections release];
    [_selectContactItem release];
    [contactsSearchBar release];
    [searchconlistArray release];
    [[BusinessContactManager sharedInstance] setDelegate:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark Messaging methods
- (void)messageReceived:(NSNotification *)notification {
    Message *msg = notification.object;
    if ([msg.type isEqualToString:TYPE_TEXT]) {
        TextMessage* textMsg = (TextMessage*)msg;
        if (textMsg.content.type == eChatIncoming) {
            for (int i=0; i < [_contactSections count]; i++) {
                NSArray* section = [_contactSections objectAtIndex:i];
                for (BusinessContact* bContact in section) {
                    if (bContact.contact.contactId == [textMsg.content.peerId intValue]) {
                        bContact.contact.missedMsgCount = bContact.contact.missedMsgCount+1;
                    }
                }
            }
            [self.tableView reloadData];
        }
    }
}

@end
