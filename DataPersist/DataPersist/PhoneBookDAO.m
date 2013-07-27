//
//  ContactsDAO.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhoneBookDAO.h"
#import "Utilities/ContactBuilder.h"
#import "Utilities/DTConstants.h"

#define CONTACT_FILE @"contacts"
#define FAVOURITE_FILE @"favourite"

@interface PhoneBookDAO()
-(void) purgeFavouriteContacts;
-(void) convertContactArray:(NSArray*) contacts intoDictArray:(NSMutableArray*) dicArray;
@end


@implementation PhoneBookDAO

-(id)initWithImpl:(id<PersistImpl>) persistImpl
{
    self = [super init];
    if(self){
        _impl = [persistImpl retain];
        _isLoad = NO;
        _contacts = [[NSMutableArray alloc] init];
        _favContacts= [[NSMutableArray alloc] init]; 
        _shortcutContacts = [[NSMutableArray alloc] init];
        _timestamp = nil;
        [self load];
    }
    return self;
}

-(void)load
{
    if(_isLoad)
    {
        return;
    }
    NSDictionary* dict = [_impl loadAsDictionaryFromKey:CONTACT_FILE];
    _timestamp = [[dict objectForKey:kPhoneBookTimestamp] retain];
    NSArray* contacts = [dict objectForKey:kPhoneBookContacts];
    for(NSDictionary* dic in contacts)
    {
        [_contacts addObject:[ContactBuilder buildFromDict:dic]];
    }
    NSArray* shortcutContacts = [dict objectForKey:kPhoneBookShortcut];
    for(NSDictionary* dic in shortcutContacts)
    {
        [_shortcutContacts addObject:[ContactBuilder buildFromDict:dic]];
    }
    NSArray *favArr = [_impl loadAsArrayFromKey:FAVOURITE_FILE];
    for(NSDictionary* dic in favArr)
    {
        [_favContacts addObject:[ContactBuilder buildFromDict:dic]];
    }
    _isContactsDirty=_isFavDirty = NO;
    _isLoad = YES;
    
}

-(void)store
{
    if(_isContactsDirty)
    {
        NSMutableArray* dicArr = [[NSMutableArray alloc]initWithCapacity:[_contacts count]];
        [self convertContactArray:_contacts intoDictArray:dicArr];
        NSMutableArray* shortcutDicArr = [[NSMutableArray alloc]initWithCapacity:[_shortcutContacts count]];
        [self convertContactArray:_shortcutContacts intoDictArray:shortcutDicArr];
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:_timestamp,kPhoneBookTimestamp,
                              dicArr,kPhoneBookContacts,shortcutDicArr,kPhoneBookShortcut, nil] ;
        [dicArr release];
        [shortcutDicArr release];
        [_impl persistAllWithDictionary:dict toKey:CONTACT_FILE]; 
        _isContactsDirty = NO;
    }
   
    if(_isFavDirty)
    {
        NSMutableArray* favDicArr = [[NSMutableArray alloc]initWithCapacity:[_favContacts count]];
        [self convertContactArray:_favContacts intoDictArray:favDicArr];
        [_impl persistAllWithArray:favDicArr toKey:FAVOURITE_FILE];
        [favDicArr release];
        _isFavDirty = NO;
    }
}


-(void) convertContactArray:(NSArray*) contacts intoDictArray:(NSMutableArray*) dicArray;
{
    for(Contact* contact in contacts)
    {
        [dicArray addObject:[ContactBuilder toDictionary:contact]];
    }
}

-(NSArray *)getContacts
{
    return [NSArray arrayWithArray:_contacts];
}

-(NSArray *)getFavouriteContacts
{
    return [NSArray arrayWithArray:_favContacts];
}

//-(NSArray *)getShortcutContacts
//{
//    return [NSArray arrayWithArray:_shortcutContacts];
//}

-(BOOL)isInPhonebook:(NSString*)contactName
{
    for(Contact* contact in _contacts)
    {
        if([contact.name isEqualToString:contactName])
        {
            return YES;
        }
    }
    return NO;
}

-(void)updateContacts:(NSArray *)contacts withTimestamp:(NSString *)timestamp
{
    [_timestamp release];
    _timestamp = [timestamp retain];
    [_contacts removeAllObjects];
    [_contacts addObjectsFromArray:contacts];
    _isContactsDirty = YES;
    [self purgeFavouriteContacts];
    
}

-(void)addFavouriteContact:(Contact *)contact
{
    [_favContacts addObject:contact];
    _isFavDirty = YES;
}

-(NSString *)getTimestamp
{
    return _timestamp;
}

-(void)removeFavouriteContact:(Contact *)contact
{
    for(NSInteger i = [_favContacts count] -1;i>=0;i--)
    {
        Contact* c = [_favContacts objectAtIndex:i];
        if(c.contactId == contact.contactId)
        {
            [_favContacts removeObjectAtIndex:i];
            _isFavDirty = YES;
            break;
        }
    }
}

-(void)addShortcutContact:(Contact *)contact
{
    [_shortcutContacts addObject:contact];
    _isContactsDirty = YES;
}

-(void)purgeFavouriteContacts
{
    for(NSInteger i=[_favContacts count] - 1;i>=0;i--)
    {
        Contact* contact = [_favContacts objectAtIndex:i];
        BOOL needRemove = YES;
        for (Contact* c in _contacts) {
            if(c.contactId == contact.contactId)
            {
                needRemove = NO;
                break;
            }
        }
        if(needRemove)
        {
            [_favContacts removeObjectAtIndex:i];
            _isFavDirty = YES;
        }
    }
}

-(void)dealloc
{
    [_impl release];
    [_contacts release];
    [_favContacts release];
    [_shortcutContacts release];
    [_timestamp release];
    [super dealloc];
}

-(void)clean
{
    [_contacts removeAllObjects];
    [_favContacts removeAllObjects];
    [_shortcutContacts removeAllObjects];
    _timestamp = nil;
    _isLoad = FALSE;
//    [_contacts release];
//    _contacts = nil;
//    [_favContacts release];
//    _favContacts = nil;
//    [_shortcutContacts release];
//    _shortcutContacts = nil;
//    [_timestamp release];
//    _timestamp = nil;
    [_impl cleanForKey:CONTACT_FILE];
    
    [_impl cleanForKey:FAVOURITE_FILE];
    
}

- (void)cleanAllContactsAndShortcutContacts{
    [_contacts removeAllObjects];
    [_shortcutContacts removeAllObjects];
    _timestamp = nil;
    _isLoad = FALSE;
    [_impl cleanForKey:CONTACT_FILE];
}

- (NSArray *)filterUserContact:(NSArray *)contacts
{
    NSMutableArray *returnValue = [[[NSMutableArray alloc] init] autorelease];
    if(contacts && [contacts count] > 0){
        for (Contact *contact in contacts) {
            if(contact.type == USER_CONTACT ) {
                [returnValue addObject:contact];
            }
        }
    }
    return [NSArray arrayWithArray:returnValue];
}

//- (NSArray *)filterShortcutContact:(NSArray *)contacts
//{
//    NSMutableArray *returnValue = [[[NSMutableArray alloc] init] autorelease];
//    if(contacts && [contacts count] > 0){
//        for (Contact *contact in contacts) {
//            if(contact.type == GROUP_CONTACT && contact.isShortcut ) {
//                [returnValue addObject:contact];
//            }
//        }
//    }
//    return [NSArray arrayWithArray:returnValue];
//}

- (void)updateFavouriteContacts:(NSArray *)contacts
{
    [_favContacts removeAllObjects];
    [_favContacts addObjectsFromArray:contacts];
    _isFavDirty = YES;
}

-(Contact *)getContactByName:(NSString*)contactName
{
    for(Contact* contact in _contacts)
    {
        if([contact.name isEqualToString:contactName])
        {
            return contact;
        }
    }
    return nil;
}

@end
