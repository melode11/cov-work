//
//  SAJSONContactsAgent.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONPhoneBookAgent.h"
#import "ContactBuilder.h"
#import "SAReqParameter.h"

@interface SAJSONPhoneBookAgent()
- (Contact*)extractNameInfo:(Contact*) contact;
@end

@implementation SAJSONPhoneBookAgent

-(void)parseBusinessObject:(NSDictionary *)dict code:(NSInteger)bizcode andTimeStamp:(NSString*)timestamp
{
    //lastest update with server, put timestamp in businessobject with "lastmodified" key.
    _timestamp = [[dict objectForKey:@"lastmodified"] retain];
    _isUpdated = [[dict objectForKey:@"isupdated"]boolValue];
    if(_isUpdated){
        NSArray* array = [dict objectForKey:kPHONEBOOK];
        NSMutableArray* tmpContacts = [NSMutableArray arrayWithCapacity:[array count]];
        for(NSDictionary* dic in array)
        {
            [tmpContacts addObject: [self extractNameInfo:[ContactBuilder buildFromDict:dic]]];
        }
        _contacts = [[NSArray alloc] initWithArray:tmpContacts];
    }
}

-(NSArray *)getContacts
{
    return _contacts;
}

-(void)requestPhoneBook:(NSString *)timestamp withLoginname:(NSString*)loginName
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:4];
    if(timestamp != nil)
    {
        [array addObject:[SAReqParameter reqParameterWithKey:kSATimestamp andValue:timestamp]];
    }
    [array addObject:[SAReqParameter reqParameterWithKey:@"loginname" andValue:loginName]];
    [self addCommonParameters:array];
    [self requestWithService:SERVICE_PHONEBOOK andParameters:array];
}

-(NSString*)getTimestamp
{
    return _timestamp;
}

-(void)dealloc
{
    [_contacts release];
    [_timestamp release];
    [super dealloc];
}

- (BOOL)isUpdated
{
    return _isUpdated;
}

- (Contact*)extractNameInfo:(Contact*) contact
{
    if(contact.name != nil)
    {
        if(contact.firstName == nil || contact.lastName == nil || contact.devicetype == nil)
        {
            NSArray* nameDetailArr = [contact.name componentsSeparatedByString:@"."];
            if([nameDetailArr count]>1)
            {
                if(contact.firstName == nil)
                {
                    contact.firstName = [nameDetailArr objectAtIndex:0];
                }
                if(contact.devicetype == nil)
                {
                    NSString *deviceType = [nameDetailArr objectAtIndex:[nameDetailArr count]-1];
                    if ([deviceType isEqualToString:@"iphone"]) {
                        contact.devicetype = @"iPhone";
                    }
                    else if([deviceType isEqualToString:@"ipad"]) {
                        contact.devicetype = @"iPad";
                    }
                }
                //since the first is first name, last is device type, so check if we have another component in middle
                if(contact.lastName == nil && [nameDetailArr count]>2)
                {
                    contact.lastName = [nameDetailArr objectAtIndex:1];
                }
            }
        }        
    }
    return contact;
}

@end
