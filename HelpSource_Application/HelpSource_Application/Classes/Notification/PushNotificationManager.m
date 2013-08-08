//
//  PushNotificationManager.m
//  AuroraPhone
//
//  Created by Kevin on 7/4/13.
//
//

#import "PushNotificationManager.h"
#import <Utilities/constants.h>
#import "UIViewUtils.h"

static PushNotificationManager *sharedPushNotificationManger;

@implementation PushNotificationManager
@synthesize suburbanAirship;
@synthesize alterMessage;
@synthesize customData;
@synthesize receiver;
@synthesize multiAppFlag;

static bool isSandboxServer;

+ (PushNotificationManager *)sharedInstance
{
    if(sharedPushNotificationManger == nil){
        @synchronized(self){
            sharedPushNotificationManger = [[PushNotificationManager alloc] init];
            isSandboxServer = FALSE;
        }
    }
    return sharedPushNotificationManger;
}

- (void)setSandboxServer:(BOOL)isProduct
{
    if(isProduct){
        isSandboxServer = FALSE;
    } else {
        isSandboxServer = TRUE;
    }
}

- (void)dealloc
{
    self.suburbanAirship = nil;
    self.alterMessage = nil;
    self.alterMessage = nil;
    self.customData = nil;
    [super dealloc];
}

- (void)pushNotification:(NSString *)myAlterMessage customData:(NSDictionary *)myCustomData receiver:(NSString *)theReceiver
{
    [self pushNotification:myAlterMessage customData:myCustomData multiAppFlag:false receiver:theReceiver];
}

- (void)pushNotification:(NSString *)myAlterMessage customData:(NSDictionary *) myCustomData multiAppFlag:(Boolean) flag receiver:(NSString *)theReceiver
{
    self.alterMessage = myAlterMessage;
    self.customData = myCustomData;
    self.receiver = theReceiver;
    self.multiAppFlag = flag;
    
    //How do I know the remote is a group or a user
    SuburbanAirshipNotification *saNotif = nil;
    //For group and all group is iPad group
    NSString* key = nil;
    NSString* secret = nil;
    NSString* masterSecret = nil;
    //    NSString* anotherAppKey = nil;
    //    NSString* anotherAppSecret = nil;
    //    NSString* anotherAppMasterSecret = nil;
    BOOL isGroup = NO;
    if([[receiver lowercaseString] hasSuffix:@"iphone"] == TRUE) {
        //For iPhone
        if (isSandboxServer) {
            key = [NSString stringWithFormat:kiPhoneDevelopmentApplicationKey];
            secret = [NSString stringWithFormat:kiPhoneDevelopmentApplicationSecret];
            masterSecret = [NSString stringWithFormat:kiPhoneDevelopmentApplicationMasterSecret];
        } else {
            key = [NSString stringWithFormat:kiPhoneDistributionApplicationKey];
            secret = [NSString stringWithFormat:kiPhoneDistributionApplicationSecret];
            masterSecret = [NSString stringWithFormat:kiPhoneDistributionApplicationMasterSecret];
            //            anotherAppKey = [NSString stringWithFormat:kiPhoneOtherAppApplicationKey];
            //            anotherAppSecret = [NSString stringWithFormat:kiPhoneOtherAppApplicationSecret];
            //            anotherAppMasterSecret = [NSString stringWithFormat:kiPhoneOtherAppApplicationMasterSecret];
        }
    } else if([[receiver lowercaseString] hasSuffix:@"pc"] == TRUE) {
        //PC: Do nothing?
        
    } else if([[receiver lowercaseString] hasSuffix:@"ipad"] == TRUE) {
        //For iPad
        if (isSandboxServer) {
            key = [NSString stringWithFormat:kiPadDevelopmentApplicationKey];
            secret = [NSString stringWithFormat:kiPadDevelopmentApplicationSecret];
            masterSecret = [NSString stringWithFormat:kiPadDevelopmentApplicationMasterSecret];         } else {
                key = [NSString stringWithFormat:kiPadDistributionApplicationKey];
                secret = [NSString stringWithFormat:kiPadDistributionApplicationSecret];
                masterSecret = [NSString stringWithFormat:kiPadDistributionApplicationMasterSecret];
                //            anotherAppKey = [NSString stringWithFormat:kiPadOtherAppApplicationKey];
                //            anotherAppSecret = [NSString stringWithFormat:kiPadOtherAppApplicationSecret];
                //            anotherAppMasterSecret = [NSString stringWithFormat:kiPadOtherAppApplicationMasterSecret];
            }
    } else {
        //For group
        isGroup = YES;
        if (isSandboxServer) {
            key = [NSString stringWithFormat:kiPadDevelopmentApplicationKey];
            secret = [NSString stringWithFormat:kiPadDevelopmentApplicationSecret];
            masterSecret = [NSString stringWithFormat:kiPadDevelopmentApplicationMasterSecret];
        } else {
            key = [NSString stringWithFormat:kiPadDistributionApplicationKey];
            secret = [NSString stringWithFormat:kiPadDistributionApplicationSecret];
            masterSecret = [NSString stringWithFormat:kiPadDistributionApplicationMasterSecret];
            //            anotherAppKey = [NSString stringWithFormat:kiPadOtherAppApplicationKey];
            //            anotherAppSecret = [NSString stringWithFormat:kiPadOtherAppApplicationSecret];
            //            anotherAppMasterSecret = [NSString stringWithFormat:kiPadOtherAppApplicationMasterSecret];
        }
    }
    if (isGroup == YES) {
        saNotif = [SuburbanAirshipNotification alert:alterMessage
                                               sound:@"notification.caf"
                                               badge:nil
                                                date:nil
                                               alias:nil
                                                 tag:receiver
                                              queued:NO];
        
    } else {  //For individual user
        saNotif = [SuburbanAirshipNotification alert:alterMessage
                                               sound:@"notification.caf"
                                               badge:nil
                                                date:nil
                                               alias:receiver
                                                 tag:nil
                                              queued:NO];
    }
    
    if (suburbanAirship) {
        [suburbanAirship setAppKey:key];
        [suburbanAirship setAppSecret:secret];
        [suburbanAirship setAppMaster:masterSecret];
    } else {
        suburbanAirship = [[SuburbanAirship alloc] initWithDelegate:self
                                                                key:key
                                                             secret:secret
                                                             master:masterSecret];
    }
    if(myCustomData != nil){
        saNotif.customData = myCustomData;
    }
    [suburbanAirship pushSuburbanAirshipNotification:saNotif];
    //    if(flag && !isSandboxServer && anotherAppKey != nil){
    //        [suburbanAirship setAppKey:anotherAppKey];
    //        [suburbanAirship setAppSecret:anotherAppSecret];
    //        [suburbanAirship setAppMaster:anotherAppMasterSecret];
    //        [suburbanAirship pushSuburbanAirshipNotification:saNotif];
    //    }
}

- (void)pushSucceeded:(NSArray *)aliases; {
	//DDLogInfo(@"Push Succeeded for alias %@", aliases);
}

- (void)pushFailed:(NSArray *)aliases {
	//DDLogInfo(@"Push Failed for alias %@", aliases);
    [UIViewUtils dismissAlterViewsSubviews:[[UIApplication sharedApplication] windows] finishBlock:nil];
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Send notification failed", @"")
                                       message:NSLocalizedString(@"Retry push?", @"")
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                             otherButtonTitles:NSLocalizedString(@"Retry", @""), nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // Retry sending notification
        [self pushNotification:self.alterMessage customData:self.customData multiAppFlag:self.multiAppFlag receiver:self.receiver];
    }
}

@end
