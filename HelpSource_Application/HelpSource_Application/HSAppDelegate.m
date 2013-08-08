//
//  HSAppDelegate.m
//  HelpSource_Application
//
//  Created by Yao Melo on 5/22/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "HSAppDelegate.h"
#import <Foundation/Foundation.h>
#import <UrbanAirship-iOS-SDK/UAPush.h>
#import <UrbanAirship-iOS-SDK/UAirship.h>
#import "PushNotificationManager.h"

int ddLogLevel = LOG_LEVEL_INFO;

@implementation HSAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DDLogInfo(@"***** didFinishLaunchingWithOptions *****");
    // Get APNS sandbox server flag from AirshipConfig.plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AirshipConfig" ofType:@"plist"];
    NSDictionary *configDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *buildType = [configDic valueForKey:@"APP_STORE_OR_AD_HOC_BUILD"];
    if([buildType isEqualToString:@"NO"]){
        [[PushNotificationManager sharedInstance] setSandboxServer:NO];
    } else {
        [[PushNotificationManager sharedInstance] setSandboxServer:YES];
    }
    [configDic release];
    
    // Init UrbanAirship
    NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    // Create Airship singleton that's used to talk to Urban Airhship servers.
    // Please populate AirshipConfig.plist with your info from http://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];
    [[UAPush shared] resetBadge];//zero badge on startup
    
    // To avoid Notification is not enabled due to some system problem, force all types on. - Themis
    [[UAPush shared] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound];
    
    // window has been loaded according to main story board.
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Delegates for receving the APNS
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    UIRemoteNotificationType notificationType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    DDLogInfo(@"***** didRegisterForRemoteNotificationsWithDeviceToken type: %d *****", notificationType);
    DDLogInfo(@"Device Token:%@", deviceToken);
    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)registerDeviceTokenFailed:(UA_ASIHTTPRequest *)request
{
    DDLogInfo(@"***** registerDeviceTokenFailed *****");
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    DDLogInfo(@"***** didFailToRegisterForRemoteNotificationsWithError *****");
    DDLogInfo(@"Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DDLogInfo(@"***** didReceiveRemoteNotification *****");
}

@end
