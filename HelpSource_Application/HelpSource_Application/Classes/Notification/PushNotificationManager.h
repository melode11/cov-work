//
//  PushNotificationManager.h
//  AuroraPhone
//
//  Created by Kevin on 7/4/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Notification/SuburbanAirship.h>

@interface PushNotificationManager : NSObject<UIAlertViewDelegate>

@property(nonatomic,retain) SuburbanAirship *suburbanAirship;
@property(nonatomic,retain) NSString *alterMessage;
@property(nonatomic,retain) NSDictionary *customData;
@property(nonatomic,retain) NSString *receiver;
@property(nonatomic) Boolean multiAppFlag;

+ (PushNotificationManager *)sharedInstance;
- (void)setSandboxServer:(BOOL)isProduct;
- (void)pushNotification:(NSString *)myAlterMessage customData:(NSDictionary *)myCustomData receiver:(NSString *)receiver;
- (void)pushNotification:(NSString *)myAlterMessage customData:(NSDictionary *) myCustomData multiAppFlag:(Boolean) flag receiver:(NSString *)receiver;

@end

