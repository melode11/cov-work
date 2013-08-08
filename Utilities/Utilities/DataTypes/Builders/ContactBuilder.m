//
//  ContactBuilder.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContactBuilder.h"
#import "DTConstants.h"
#import "NSDictionary+SafeAccess.h"

@implementation ContactBuilder

+(Contact *)buildFromDict:(NSDictionary *)dict
{
    Contact* contact = [[[Contact alloc]init]autorelease];
    contact.contactId = [[dict objectForKeyNullToNil:kContactId] intValue];
    contact.name = [dict objectForKeyNullToNil:kContactName];
    contact.type = [[dict objectForKeyNullToNil:kContactType]intValue];
    contact.displayName = [dict objectForKeyNullToNil:kContactDisplayName];
    contact.missedMsgCount = [[dict objectForKeyNullToNil:kContactMsgMissedCount] intValue];
    return contact;
}

+(NSDictionary*)toDictionary:(Contact*) contact
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",contact.contactId],kContactId,
            contact.name,kContactName,[NSNumber numberWithInt:contact.type],kContactType,
            contact.displayName,kContactDisplayName, contact.missedMsgCount, kContactMsgMissedCount,
            nil];
}

@end
