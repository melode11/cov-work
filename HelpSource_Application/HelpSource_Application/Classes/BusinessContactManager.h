//
//  BussinessContactManager.h
//  HelpSource_Application
//
//  Created by Yao Melo on 7/24/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessContact.h"


@interface BusinessContactManager : NSObject
{
    NSComparator _idComparator;
    NSMutableArray *_sortedBusinessContacts;
    
    BOOL _isDirty;
    NSArray* _alphabeticBusinessContacts;
}

+(BusinessContactManager*) sharedInstance;

-(void)setContacts:(NSArray*)contacts;

-(void) updateStatus:(NSDictionary*) statusMapping devices:(NSDictionary*)activeDevicesMapping;

-(void) updateStatus:(ContactStatus)status andDevices:(NSArray*)activeDevices forContact:(Contact*)contact;

@property (nonatomic,readonly) NSArray* businessContacts;

@property (nonatomic,readonly) NSArray* businessContactsInAlphabeticOrder;

@end
