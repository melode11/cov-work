//
//  UserProfile.h
//  AuroraPhone
//
//  Created by Melo Yao on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductGroup.h"

@interface UserProfile : NSObject

@property(nonatomic,assign) NSInteger userId;

@property(nonatomic,retain) NSString* name;

@property(nonatomic,retain) NSString* displayName;

@property(nonatomic,retain) ProductGroup* productGroup;

@end
