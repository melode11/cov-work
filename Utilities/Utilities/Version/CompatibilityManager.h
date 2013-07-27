//
//  CompatibilityManager.h
//  Utilities
//
//  Created by Yao Melo on 6/26/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CompatibilityManager : NSObject


{
    
    // SipID for user who accepted the call
    NSString* targetSipName;
    
    unsigned long versionValue;
}


@property (nonatomic, retain) NSString* targetAppVersion;

@property (nonatomic, retain) NSString* targetSipName;

+ (CompatibilityManager *)sharedManager;

- (BOOL) isTargetSupportToggle;

- (BOOL) isTargetSupportAnnotationCompression;

- (BOOL) isTargetVersionLower;
@end
