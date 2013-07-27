//
//  BussinessContactManager.m
//  HelpSource_Application
//
//  Created by Yao Melo on 7/24/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "BusinessContactManager.h"
#import "DataPersist/DataPersist.h"

static BusinessContactManager* sharedInstance = nil;

@interface BusinessContactManager ()

@end

@implementation BusinessContactManager

+(BusinessContactManager *)sharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[BusinessContactManager alloc] init];
    }
    return sharedInstance;
}

-(oneway void)release
{
    
}

+(id)copyWithZone:(NSZone *)zone
{
    return nil;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _idComparator = Block_copy( ^(id obj1,id obj2)
                                   {
                                       
                                       NSInteger cid1 = ((BusinessContact*)obj1).contact.contactId;
                                       NSInteger cid2 = ((BusinessContact*)obj2).contact.contactId;
                                       return cid1<cid2?NSOrderedAscending:cid1 == cid2?NSOrderedSame:NSOrderedDescending;
                                   });
        
    }
    return self;
}

-(void)setContacts:(NSArray *)contacts
{
    NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:[contacts count]];
    for (Contact* contact in contacts) {
        BusinessContact* item = [[BusinessContact alloc] initWithContact:contact];
        [output addObject:item];
        [item release];
    }
    [output sortUsingComparator:_idComparator];
    [_sortedBusinessContacts release];
    _sortedBusinessContacts = output;
    _isDirty = YES;
}

-(void)updateStatus:(NSDictionary*) statusMapping devices:(NSDictionary*)activeDevicesMapping
{
    for (BusinessContact *contact in _sortedBusinessContacts) {
        NSNumber *statusFlag = [statusMapping objectForKey:[NSNumber numberWithInteger:contact.contact.contactId]];
        if(statusFlag)
        {
            [contact setStatusFlags:[statusFlag integerValue]];
            if([contact isMessagingOnline])
            {
                NSArray* activeDevices = [activeDevicesMapping objectForKey:[NSNumber numberWithInteger:contact.contact.contactId]];
                contact.activeDevices = activeDevices;
            }
            else
            {
                contact.activeDevices = nil;
            }
        }
    }
}


-(void) insertContact:(Contact*) contact
{
    BusinessContact* item = [[BusinessContact alloc] initWithContact:contact];
    NSRange range;
    range.location = 0;
    range.length = [_sortedBusinessContacts count];
    //binary search for performance.
    NSInteger index = [_sortedBusinessContacts indexOfObject:item inSortedRange:range options:NSBinarySearchingInsertionIndex usingComparator:_idComparator];
    [_sortedBusinessContacts insertObject:item atIndex:index];
    [item release];
    _isDirty = YES;
}

-(void) updateStatus:(ContactStatus)status andDevices:(NSArray*)activeDevices forContact:(Contact*)contact
{
    BusinessContact* item = [[BusinessContact alloc] initWithContact:contact];
    //binary search for performance.
    NSRange range;
    range.location = 0;
    range.length = [_sortedBusinessContacts count];
    NSInteger index = [_sortedBusinessContacts indexOfObject:item inSortedRange:range options:NSBinarySearchingInsertionIndex usingComparator:_idComparator];
    if(index != NSNotFound)
    {
        BusinessContact* bscontact = ((BusinessContact*)[_sortedBusinessContacts objectAtIndex:index]);
        bscontact.activeDevices = activeDevices;
        [bscontact setStatusFlags:status];
    }
    [item release];
}

-(NSArray *)businessContactsInAlphabeticOrder
{
    if(_isDirty||_alphabeticBusinessContacts == nil)
    {
        _isDirty = NO;
        [_alphabeticBusinessContacts release];
        _alphabeticBusinessContacts = [[_sortedBusinessContacts sortedArrayUsingComparator: ^(id obj1,id obj2)
                                       {
                                           BusinessContact* contact1 = (BusinessContact*)obj1;
                                           BusinessContact* contact2 = (BusinessContact*)obj2;
                                           unichar tag1 = [contact1 groupTag];
                                           unichar tag2 = [contact2 groupTag];
                                           if(tag1>='A'&&tag1<='Z')
                                           {
                                               if(tag2>='A'&&tag2<='Z')
                                               {
                                                   return [[contact1 sortableName] caseInsensitiveCompare:[contact2 sortableName]];
                                               }
                                               else
                                               {
                                                   return NSOrderedAscending;
                                               }
                                           }
                                           else
                                           {
                                               if(tag2>='A'&&tag2<='Z')
                                               {
                                                   return NSOrderedDescending;
                                               }
                                               else
                                               {
                                                    return [[contact1 sortableName] caseInsensitiveCompare:[contact2 sortableName]];
                                               }

                                           }
                                       }] retain];
    }
    return _alphabeticBusinessContacts;
}

-(NSArray *)businessContacts
{
    return _sortedBusinessContacts;
}

- (void)dealloc
{
    [_sortedBusinessContacts release];
    [_alphabeticBusinessContacts release];
    Block_release(_idComparator);
    [super dealloc];
}

@end
