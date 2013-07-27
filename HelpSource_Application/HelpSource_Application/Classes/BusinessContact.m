//
//  ContactItem.m
//  HelpSource_Application
//
//  Created by Yao Melo on 7/23/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "BusinessContact.h"
#import "Utilities/NSString+Name_Device.h"

@implementation BusinessContact

-(id)initWithContact:(Contact *)contact
{
    self = [super init];
    if(self)
    {
        _contact = [contact retain];
        _status.statusValue = 0;
    }
    return self;
}

-(NSString *)sortableName
{
    if(_contact)
    {
        if(_sortableNameCache== nil)
        {
            _sortableNameCache = [[_contact.displayName lastNameFirstName] retain];
        }
        return _sortableNameCache;
    }
    return nil;
}

-(unichar)groupTag
{
    if(_contact == nil)
    {
        return 0;
    }
    if(_groupTag == 0)
    {
        unichar tag = [[self sortableName] characterAtIndex:0];
        if(tag >= 'A' && tag <= 'Z')
        {
            _groupTag = tag;
        }
        else
        {
            _groupTag = '#';
        }
    }
    return _groupTag;
}

-(BOOL)isMessagingOnline
{
    return _status.statusFlags.messagingOnline>0;
}

-(BOOL)isSessionOnline
{
    return _status.statusFlags.sessionOnline>0;
}

-(void)setStatusFlags:(ContactStatus)status
{
    _status.statusValue = status;
}

- (void)dealloc
{
    [_sortableNameCache release];
    [_contact release];
    [_activeDevices release];
    [super dealloc];
}

@end
