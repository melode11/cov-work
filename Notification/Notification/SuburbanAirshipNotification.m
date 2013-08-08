//
//  SuburbanAirshipNotification.m
//  The Now
//
//  Created by Chad Podoski on 1/4/10.
//  Copyright 2010 Shacked Software. All rights reserved.
//
/*
 Copyright (c) 2010, Shacked Software (dev@shackedsoftware.com)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 - Neither the name of the copyright holder nor the names of its contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */


#import "SuburbanAirshipNotification.h"

@implementation SuburbanAirshipNotification
@synthesize alert;
@synthesize sound;
@synthesize badge;
@synthesize date;
@synthesize alias;
@synthesize queued;
@synthesize userAliases;
@synthesize customData;
@synthesize tag;

+ (id)alert:(NSString *)theAlert sound:(NSString *)theSound	badge:(NSNumber *)theBadge date:(NSDate *)theDate alias:(NSString *)theAlias tag:(NSString*)tag queued:(BOOL)theQueued
{
	SuburbanAirshipNotification *notif = [[[SuburbanAirshipNotification alloc] init] autorelease];
    
	notif.alert = theAlert;
	notif.sound = theSound;
	notif.badge = theBadge;
	notif.date = theDate;
	notif.alias = theAlias;
	notif.queued = theQueued;
    notif.tag = tag;
    notif.userAliases = [NSArray arrayWithObjects:notif.alias, nil];
    notif.customData = [NSDictionary dictionary];
    
	return notif;
}

- (BOOL)validNotification; {
	if ((self.alert != nil && [self.alert length] != 0) ||
		(self.sound != nil && [self.sound length] != 0) ||
		(self.badge != nil)) {
		return YES;
	}
	else {
		return NO;
	}
}

- (void)dealloc {
    [alert release], alert = nil;
    [sound release], sound = nil;
    [badge release], badge = nil;
    [date release], date = nil;
    [alias release], alias = nil;
    [tag release], tag = nil;
    [userAliases release], userAliases = nil;
    [customData release], customData = nil;
    [super dealloc];
}

@end

