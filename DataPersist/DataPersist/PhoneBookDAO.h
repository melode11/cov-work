//
//  ContactsDAO.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseDAO.h"
#import "PersistImpl.h"
#import "Utilities/Contact.h"

#define kPhoneBookContacts @"contacts"

#define kPhoneBookTimestamp @"timestamp"

#define kPhoneBookFavourite @"favourite"

#define kPhoneBookShortcut @"shortcut"


@interface PhoneBookDAO : BaseDAO
{
    @private
    id<PersistImpl> _impl;
    BOOL _isLoad;
    BOOL _isFavDirty;
    BOOL _isContactsDirty;
    NSString* _timestamp;
    NSMutableArray* _contacts;
    NSMutableArray* _favContacts;
    NSMutableArray* _shortcutContacts;
}

-(id)initWithImpl:(id<PersistImpl>) persistImpl;

-(void)updateContacts:(NSArray*) contacts withTimestamp: (NSString*)timestamp;

-(NSArray*) getContacts;

-(void) addFavouriteContact:(Contact*) contact;

-(NSArray*) getFavouriteContacts;

-(void) addShortcutContact:(Contact*) contact;

//-(NSArray*) getShortcutContacts;

-(void)removeFavouriteContact:(Contact*) contact;

-(BOOL)isInPhonebook:(NSString*)contactName;

-(NSString*) getTimestamp;

- (NSArray *)filterUserContact:(NSArray *)contacts;

//- (NSArray *)filterShortcutContact:(NSArray *)contacts;

- (void)updateFavouriteContacts:(NSArray *)contacts;

- (void)cleanAllContactsAndShortcutContacts;

-(Contact *)getContactByName:(NSString*)contactName;

@end
