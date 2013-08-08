//
//  SuburbanAirship.m
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

// TODO: Persist notifDict so user does not have to track aliases if they don't want to

#import <SystemConfiguration/SystemConfiguration.h>
#import "SuburbanAirship.h"
#import "ASIHTTPRequest.h"
#import "UA_SBJSON.h"
#import "Reachability.h"
#import "UA_Reachability.h"

@interface SuburbanAirship ()

@property (nonatomic, readwrite, retain) NSString *_deviceToken;
@property (nonatomic, readwrite, retain) NSString *deviceToken;
@property (nonatomic, readwrite, retain) NSString *deviceAlias;
@property (nonatomic, readwrite, retain) NSMutableArray *deviceTags;
@property (nonatomic, retain) NSMutableArray *requestQueue;
@property (nonatomic, retain) NSMutableDictionary *notifDict;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

- (NSString *)guid;
- (ASIHTTPRequest *)requestForNotification:(SuburbanAirshipNotification *)notif;
- (NSDictionary *)jsonForNotification:(SuburbanAirshipNotification *)notif;
- (void)saTokenSucceeded:(ASIHTTPRequest *)request;
- (void)saTokenFailed:(ASIHTTPRequest *)request;
- (void)saPushSucceeded:(ASIHTTPRequest *)request;
- (void)saPushFailed:(ASIHTTPRequest *)request;
- (void)saCancelSucceeded:(ASIHTTPRequest *)request;
- (void)saCancelFailed:(ASIHTTPRequest *)request;

@end


@implementation SuburbanAirship

@synthesize delegate;
@synthesize batchModePush;
@synthesize batchModeCancel;
@synthesize _deviceToken;
@synthesize deviceToken;
@synthesize deviceAlias;
@synthesize deviceTags;
@synthesize appKey;
@synthesize appSecret;
@synthesize appMaster;
@synthesize requestQueue;
@synthesize notifDict;
@synthesize operationQueue;

static NSString *SABaseURL = @"go.urbanairship.com";
static NSString *SADeviceTokenURL = @"https://go.urbanairship.com/api/device_tokens/";
static NSString *SAPushURL = @"https://go.urbanairship.com/api/push/";
static NSString *SAScheduledAliasURL = @"https://go.urbanairship.com/api/push/scheduled/alias/";
//static NSString *SABatchURL = @"https://go.urbanairship.com/api/push/batch/";
static NSString *SACancelURL = @"https://go.urbanairship.com/api/push/scheduled/";
static NSString *SAUserInfoScheduledAliasKey = @"SAUserInfoScheduledAlias";

//static NSString *SAJSONDeviceTokenKey = @"device_tokens";
//static NSString *SAJSONScheduleForKey = @"schedule_for";
//static NSString *SAJSONScheduledAliasKey = @"alias";
//static NSString *SAJSONScheduledTimeKey = @"scheduled_time";
static NSString *SAJSONAPSKey = @"aps";
static NSString *SAJSONBadgeKey = @"badge";
static NSString *SAJSONAlertKey = @"alert";
static NSString *SAJSONSoundKey = @"sound";
static NSString *SAJSONAliasKey = @"alias";
static NSString *SAJSONCancelAliasesKey = @"cancel_aliases";
static NSString *SAJSONCancelTokenKey = @"cancel_device_tokens";
static NSString *SAJSONTagsKey = @"tags";
//static NSString *SAJSONScheduledURLKey = @"scheduled_notifications";
//static NSString *SAJSONCancelURLKey = @"cancel";
static NSString *SAJSONTokenAliasesKey = @"aliases";
//static NSString *SAJSONExcludeTokensKey = @"exclude_tokens";
//static NSString *LOCAL_KEY = @"loc-key";
//static NSString *LOCAL_ARGS = @"loc-args";
//static NSString *ACTION_LOCAL_KEY = @"action-loc-key";
static NSString *SAJSONBODY= @"body";

- (id)init
{
	return [self initWithDelegate:nil key:nil secret:nil master:nil];
}

- (id)initWithDelegate:(id)theDelegate key:(NSString*)key secret:(NSString *)secret master:(NSString *)master
{
	if ((self = [super init]) != nil) {
		delegate = [theDelegate retain];
		batchModePush = NO;
		batchModeCancel = YES;
		
		appKey = [key retain];
		appSecret = [secret retain];
		appMaster = [master retain];
		
		requestQueue = [[NSMutableArray alloc] init];
		notifDict = [[NSMutableDictionary alloc] init];
		operationQueue = [[NSOperationQueue alloc] init];
	}
	return self;
}

- (void)dealloc
{
	self.delegate = nil;
	self.deviceToken = nil;
	self.deviceAlias = nil;
	self.deviceTags = nil;
	self.appKey = nil;
	self.appSecret = nil;
	self.appMaster = nil;
	self.requestQueue = nil;
	self.notifDict = nil;
	self.operationQueue = nil;
	[super dealloc];
}

- (NSString *)guid;
{
	CFUUIDRef guid = NULL;
	
	@try {
		guid = CFUUIDCreate(NULL);
		return [(NSString *)CFUUIDCreateString(NULL, guid) autorelease];
	}@finally {
		if(guid) {
			CFRelease(guid);
		}
	}
	return nil;
}

#pragma mark Registration Methods
- (void)putDeviceToken:(NSData *)token
{
	[self putDeviceToken:token withDeviceAlias:nil withDeviceTags:nil];
}

- (void)putDeviceToken:(NSData *)token withDeviceAlias:(NSString *)alias
{
	[self putDeviceToken:token withDeviceAlias:alias withDeviceTags:nil];
}

- (void)putDeviceToken:(NSData *)token withDeviceAlias:(NSString *)alias withDeviceTags:(NSArray *)tags
{
	/* Get a hex string from the device token with no spaces or < > */
	self._deviceToken = [[[[token description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
						  stringByReplacingOccurrencesOfString:@">" withString:@""]
						 stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	/* Build the ASIHTTPRequest */
	NSString *urlString = [NSString stringWithFormat:@"%@%@/", SADeviceTokenURL, self._deviceToken];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	request.requestMethod = @"PUT";
	request.username = self.appKey;
	request.password = self.appSecret;
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(saTokenSucceeded:)];
	[request setDidFailSelector:@selector(saTokenFailed:)];
	
	/* Append JSON Payload if alias or tags specified */
	if ((alias != nil && [alias	length] != 0) ||
		(tags != nil && [tags count] != 0)) {
		
		NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithCapacity:2];
		
		if (alias != nil && [alias	length] != 0) {
			[jsonDict setObject:alias forKey:SAJSONAliasKey];
		}
		
		if (tags != nil && [tags count] != 0) {
			[jsonDict setObject:tags forKey:SAJSONTagsKey];
		}
        
        UA_SBJsonWriter *writer = [[UA_SBJsonWriter alloc] init];
        writer.humanReadable = NO;
        NSString *body = [writer stringWithObject:jsonDict];
		
		DDLogInfo(@"Token %@", body);
		[request addRequestHeader: @"Content-Type" value: @"application/json"];
		[request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        [writer release];
	}
	
	/* Process request using an NSOperationQueue */
	[operationQueue addOperation:request];
}

- (void)deleteDeviceToken;
{
	DDLogInfo(@"Delete device token");
	/* Build the ASIHTTPRequest */
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/", SADeviceTokenURL, self.deviceToken]];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	request.requestMethod = @"DELETE";
	request.username = self.appKey;
	request.password = self.appSecret;
    
	/* Process request using an NSOperationQueue */
	[operationQueue addOperation:request];
}

- (void)saTokenSucceeded:(ASIHTTPRequest *)request; {
	DDLogInfo(@"Token Succeeded");
	self.deviceToken = _deviceToken;
    if([delegate respondsToSelector:@selector(tokenSucceeded)]){
       	[delegate tokenSucceeded];
    }
}

- (void)saTokenFailed:(ASIHTTPRequest *)request
{
	if ([[request error] code] == ASIRequestCancelledErrorType) {
		DDLogInfo(@"Token Canceled");
        if([delegate respondsToSelector:@selector(tokenCanceled)]){
            [delegate tokenCanceled];
        }
	}
	else {
		DDLogInfo(@"Token Failed");
        if([delegate respondsToSelector:@selector(tokenFailed)]){
            [delegate tokenFailed];
        }
	}
}

#pragma mark Push Notifications Methods
- (NSString *)pushAlert:(NSString *)alert
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:nil badge:nil date:nil alias:nil tag:nil queued:NO];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)pushAlert:(NSString *)alert sound:(NSString *)sound
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:sound badge:nil date:nil alias:nil tag:nil queued:NO];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)pushAlert:(NSString *)alert sound:(NSString *)sound badge:(NSNumber *)badge
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:sound            badge:badge date:nil alias:nil tag:nil queued:NO];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)pushScheduledAlert:(NSString *)alert date:(NSDate *)date
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:nil            badge:nil date:date alias:nil tag:nil queued:NO];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)pushScheduledAlert:(NSString *)alert sound:(NSString *)sound date:(NSDate *)date
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:sound            badge:nil date:date alias:nil tag:nil queued:NO];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)pushScheduledAlert:(NSString *)alert sound:(NSString *)sound badge:(NSNumber *)badge date:(NSDate *)date
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:sound            badge:badge date:date alias:nil tag:nil queued:NO];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)queueAlert:(NSString *)alert
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:nil            badge:nil date:nil alias:nil tag:nil queued:YES];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)queueAlert:(NSString *)alert sound:(NSString *)sound
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:sound            badge:nil date:nil alias:nil tag:nil queued:YES];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)queueAlert:(NSString *)alert sound:(NSString *)sound badge:(NSNumber *)badge
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:sound            badge:badge date:nil alias:nil tag:nil queued:YES];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)queueScheduledAlert:(NSString *)alert date:(NSDate *)date
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:nil            badge:nil date:date alias:nil tag:nil queued:YES];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)queueScheduledAlert:(NSString *)alert sound:(NSString *)sound date:(NSDate *)date
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:sound            badge:nil date:date alias:nil tag:nil queued:YES];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)queueScheduledAlert:(NSString *)alert sound:(NSString *)sound badge:(NSNumber *)badge date:(NSDate *)date
{
    SuburbanAirshipNotification *notif =[SuburbanAirshipNotification alert:alert sound:sound            badge:badge date:date alias:nil tag:nil queued:YES];
	return [self pushSuburbanAirshipNotification:notif];
}

- (NSString *)pushSuburbanAirshipNotification:(SuburbanAirshipNotification *)notif
{
	NSString *alias = nil;
	
	/* Only create if one or more of parameters is valid */
	if ([notif validNotification]) {
		
		/* If user didn't specified an alias, make one up */
		if (notif.alias == nil || [notif.alias length] == 0) {
			notif.alias = [self guid];
		}
		
		/* Store guid for reference */
		alias = notif.alias;
		[notifDict setObject:notif forKey:alias];
		
		/* Notification type is either queued or send immediately */
		if (notif.queued) {
			[requestQueue addObject:notif];
		}
		else {
			[operationQueue addOperation:[self requestForNotification:notif]];
		}
	}
	return alias;
}

- (void)saPushSucceeded:(ASIHTTPRequest *)request
{
	DDLogInfo(@"Push Succeeded with Alias = %@", [[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]);
    if([delegate respondsToSelector:@selector(pushSucceeded:)]){
        [delegate pushSucceeded:[[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]];
    }
}

- (void)saPushFailed:(ASIHTTPRequest *) request
{
    NSError *error1 = [request error];
    DDLogInfo(@"Failed %@ with code %d and with userInfo %@",[error1 domain],[error1 code],[error1 userInfo]);
	if ([[request error] code] == ASIRequestCancelledErrorType) {
		DDLogInfo(@"Push Cancelled with Alias = %@", [[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]);
        if([delegate respondsToSelector:@selector(pushCanceled:)]){
            [delegate pushCanceled:[[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]];
        }
	}
	else {
		DDLogInfo(@"Push Failed with Alias = %@", [[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]);
        if([delegate respondsToSelector:@selector(pushFailed:)]){
            [delegate pushFailed:[[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]];
        }
	}
}

#pragma mark Delete Scheduled Push Notifications Methods
- (void)cancelAllNotifications
{
	if (self.deviceToken != nil && [self.deviceToken length] != 0) {
		ASIHTTPRequest *request = [[[ASIHTTPRequest alloc]
									initWithURL:[NSURL URLWithString:SACancelURL]] autorelease];
		request.requestMethod = @"POST";
		request.username = self.appKey;
		request.password = self.appSecret;
		request.userInfo = [NSDictionary dictionaryWithObject:[self.notifDict allKeys]
													   forKey:SAUserInfoScheduledAliasKey];
		[request setDelegate:self];
		[request setDidFinishSelector: @selector(saCancelSucceeded:)];
		[request setDidFailSelector: @selector(saCancelFailed:)];
		
		NSDictionary *jsonDict = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:self.deviceToken] forKey:SAJSONCancelTokenKey];
		[request addRequestHeader: @"Content-Type" value: @"application/json"];
        UA_SBJsonWriter *writer = [[UA_SBJsonWriter alloc] init];
        writer.humanReadable = NO;
        NSString *body = [writer stringWithObject:jsonDict];
		[request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        [writer release];
		DDLogInfo(@"Cancel Device Token %@ and Aliases %@", self.deviceToken, [self.notifDict allKeys]);
		
		/* Process request using an NSOperationQueue */
		[operationQueue addOperation:request];
	}
}

- (void)cancelNotificationWithAlias:(NSString *)alias
{
	[self cancelNotificationsWithAliases:[NSArray arrayWithObject:alias]];
}

- (void)cancelNotificationsWithAliases:(NSArray *)aliases
{
	if (aliases != nil && [aliases count] != 0) {
		
		if (batchModeCancel) {
			ASIHTTPRequest *request = [[[ASIHTTPRequest alloc]
                                        initWithURL:[NSURL URLWithString:SACancelURL]] autorelease];
			request.requestMethod = @"POST";
			request.username = self.appKey;
			request.password = self.appSecret;
			request.userInfo = [NSDictionary dictionaryWithObject:aliases forKey:SAUserInfoScheduledAliasKey];
			[request setDelegate:self];
			[request setDidFinishSelector: @selector(saCancelSucceeded:)];
			[request setDidFailSelector: @selector(saCancelFailed:)];
			
			NSDictionary *jsonDict = [NSDictionary dictionaryWithObject:aliases forKey:SAJSONCancelAliasesKey];
			[request addRequestHeader: @"Content-Type" value: @"application/json"];
            UA_SBJsonWriter *writer = [[UA_SBJsonWriter alloc] init];
            writer.humanReadable = NO;
            NSString *body = [writer stringWithObject:jsonDict];
            [request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
			DDLogInfo(@"Cancel Aliases %@",[body dataUsingEncoding:NSUTF8StringEncoding]);
            [writer release];
			/* Process request using an NSOperationQueue */
			[operationQueue addOperation:request];
		}
		else {
			for (NSString *alias in aliases) {
				ASIHTTPRequest *request = [[[ASIHTTPRequest alloc]
                                            initWithURL:[NSURL URLWithString:[SAScheduledAliasURL stringByAppendingString:alias]]] autorelease];
				request.requestMethod = @"DELETE";
				request.username = self.appKey;
				request.password = self.appSecret;
				request.userInfo = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:alias] forKey:SAUserInfoScheduledAliasKey];
				[request setDelegate:self];
				[request setDidFinishSelector: @selector(saCancelSucceeded:)];
				[request setDidFailSelector: @selector(saCancelFailed:)];
				
				DDLogInfo(@"Cancel %@", alias);
				
				/* Process request using an NSOperationQueue */
				[operationQueue addOperation:request];
			}
		}
	}
}

- (void)saCancelSucceeded:(ASIHTTPRequest *) request
{
	DDLogInfo(@"Cancel Succeeded with Alias = %@", [[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]);
    if([delegate respondsToSelector:@selector(cancelSucceeded:)]){
      	[delegate cancelSucceeded:[[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]];
    }
}

- (void)saCancelFailed:(ASIHTTPRequest *) request
{
	if ([[request error] code] == ASIRequestCancelledErrorType) {
		DDLogInfo(@"Cancel Canceled with Alias = %@", [[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]);
        if([delegate respondsToSelector:@selector(cancelCanceled:)]){
            [delegate cancelCanceled:[[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]];
        }
	}
	else {
		DDLogInfo(@"Cancel Failed with Alias = %@", [[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]);
        if([delegate respondsToSelector:@selector(cancelFailed:)]){
            [delegate cancelFailed:[[request userInfo] objectForKey:SAUserInfoScheduledAliasKey]];
        }
	}
}

#pragma mark Notifications Helper Method
- (void)sendNotificationsInQueue
{
	if (self.requestQueue != nil && [self.requestQueue count] != 0) {
		NSArray *cache = [NSArray arrayWithArray:self.requestQueue];
		self.requestQueue = [NSMutableArray array];
        
		//
		// Removed batch mode for sending because json payload does not support passing in
		// scheduled notif aliases yet.  When UA adds alias to this payload, this should be an easy addition
		//
        //		if (batchModePush) {
        //			/* Create a bulk Push request and configure its properties */
        //			ASIHTTPRequest *request = [[[ASIHTTPRequest alloc]
        //										initWithURL:[NSURL URLWithString:SABatchURL]] autorelease];
        //			request.requestMethod = @"POST";
        //			request.username = self.appKey;
        //			request.password = self.appMaster;
        //			[request setDelegate:self];
        //			[request setDidFinishSelector: @selector(saPushSucceeded:)];
        //			[request setDidFailSelector: @selector(saPushFailed:)];
        //
        //			NSMutableArray *jsonArray = [NSMutableArray arrayWithCapacity:[cache count]];
        //			for (SuburbanAirshipNotification *notif in cache) {
        //				[jsonArray addObject:[self jsonForNotification:notif]];
        //			}
        //
        //			[request addRequestHeader:@"Content-Type" value:@"application/json"];
        //			[request appendPostData:[[[CJSONSerializer serializer] serializeArray:jsonArray] dataUsingEncoding:NSUTF8StringEncoding]];
        //
        //			DLog(@"Push %@", [[CJSONSerializer serializer] serializeArray:jsonArray]);
        //
        //			/* Process request using an NSOperationQueue */
        //			[operationQueue addOperation:request];
        //
        //		}
        //		else {
        for (SuburbanAirshipNotification *notif in cache) {
            [operationQueue addOperation:[self requestForNotification:notif]];
        }
        //		}
	}
}

- (ASIHTTPRequest *)requestForNotification:(SuburbanAirshipNotification *)notif
{
	/* Create a single notification Push request and configure its properties */
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc]
								initWithURL:[NSURL URLWithString:SAPushURL]] autorelease];
	request.requestMethod = @"POST";
	request.username = self.appKey;
	//request.password = [notif.userAliases count] ? self.appMaster : self.appSecret;
	request.password = self.appMaster;
    request.userInfo = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:notif.alias] forKey:SAUserInfoScheduledAliasKey];
	[request setDelegate:self];
	[request setDidFinishSelector: @selector(saPushSucceeded:)];
    [request setDidFailSelector:@selector(saPushFailed:)];
	[request setValidatesSecureCertificate:NO];
	
	/* Build JSON Payload */
	NSDictionary *jsonDict = [self jsonForNotification:notif];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
    UA_SBJsonWriter *writer = [[UA_SBJsonWriter alloc] init];
    writer.humanReadable = NO;
    NSString *body = [writer stringWithObject:jsonDict];
    [request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    DDLogInfo(@"jsonDict Push: %@", jsonDict);
    [writer release];
	return request;
}

- (NSDictionary *)jsonForNotification:(SuburbanAirshipNotification *)notif
{
	NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithCapacity:6];
	NSMutableDictionary *apsDict = [NSMutableDictionary dictionaryWithCapacity:3];
	NSMutableDictionary *subapsDict = [NSMutableDictionary dictionaryWithCapacity:2];
	//NSString( locArge
    
	if (notif.alert != nil && [notif.alert	length] != 0) {
        [subapsDict setObject:notif.alert forKey:SAJSONBODY];
        //[subapsDict setObject:@"Show" forKey:ACTION_LOCAL_KEY];
		[apsDict setObject:subapsDict forKey:SAJSONAlertKey];
	}
    //What kind of rington we need
	if (notif.sound != nil && [notif.sound	length] != 0) {
		[apsDict setObject:notif.sound forKey:SAJSONSoundKey];
	}
	
	if (notif.badge != nil) {
		[apsDict setObject:notif.badge forKey:SAJSONBadgeKey];
	}
    
	if ([notif.userAliases count] > 0 ) {
        [jsonDict setObject:notif.userAliases forKey:SAJSONTokenAliasesKey];
    }
    
    if (notif.tag != nil) {
		[jsonDict setObject:[NSArray arrayWithObject:notif.tag] forKey:SAJSONTagsKey];
    }
	[jsonDict setObject:apsDict forKey:SAJSONAPSKey];
	
	if (notif.date != nil) {
		/* Set up a dateformater for ISO 8601 Format in UTC */
		NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
		[df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier: @"en_US"] autorelease]];
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		[df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        
        // NSDictionary *scheduleDict = [NSDictionary dictionaryWithObjectsAndKeys:
        // [df stringFromDate:notif.date], SAJSONScheduledTimeKey, notif.alias, SAJSONScheduledAliasKey, nil];
        // [jsonDict setObject:[NSArray arrayWithObject:scheduleDict] forKey:SAJSONScheduleForKey];
	}
    
    if ([notif.customData count]) {
        [jsonDict addEntriesFromDictionary:notif.customData];
    }
	return jsonDict;
}


#pragma mark Misc Methods
- (SuburbanAirshipNotification *)suburbanAirshipNotifForGUID:(NSString *)guid
{
	return [notifDict objectForKey:guid];
}

- (BOOL)isUrbanAirshipReachable
{
	return ([[Reachability reachabilityWithHostName:SABaseURL] currentReachabilityStatus] != NotReachable);
}

@end
