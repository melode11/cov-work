//
//  Contact.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"
#import "NSString+Name_Device.h"


@implementation Contact

-(void)dealloc
{
    [_name release];
    [_displayName release];
    [super dealloc];
}

-(NSString *)displayName
{
    if(_displayName == nil || [_displayName isEqualToString:@""]){
        if(_type == GROUP_CONTACT){
            return _name;
        } else {
            return [NSString stringWithFormat:@"%@ %@",[_name lastName],[_name firstName]];
        }
    }
    return _displayName;
}

//MELO:Override isEqual and hash to enable NSArray/NSDictionary to compare with actual content.
-(BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[Contact class]])
    {
        Contact *inContact = (Contact*)object;
        return [_name isEqualToString:inContact.name] && _contactId == inContact.contactId;
    }
    return NO;
}

-(NSUInteger)hash
{
    NSInteger prime = 37;
    return [_name hash]*prime + _contactId;
}


@end
