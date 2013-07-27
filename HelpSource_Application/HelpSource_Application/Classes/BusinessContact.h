//
//  ContactItem.h
//  HelpSource_Application
//
//  Created by Yao Melo on 7/23/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities/Contact.h"

typedef enum
{
    SessionOnline = 1,
    MessagingOnline = 2,
} ContactStatus;//bitwise enums

@interface BusinessContact : NSObject
{
    NSString* _sortableNameCache;
    unichar _groupTag;
    union
    {
        unsigned char statusValue;
        struct
        {
            unsigned char sessionOnline:1;
            unsigned char messagingOnline:1;
            unsigned char dummy:6;
        } statusFlags;
    } _status;
}


@property (nonatomic,readonly) Contact* contact;

@property (nonatomic,retain) NSArray* activeDevices;

@property (nonatomic,readonly) BOOL isMessagingOnline;

@property (nonatomic,readonly) BOOL isSessionOnline;

-(id)initWithContact:(Contact*)contact;

-(NSString*) sortableName;

-(unichar) groupTag;

-(void) setStatusFlags:(ContactStatus)statusFlags;

@end
