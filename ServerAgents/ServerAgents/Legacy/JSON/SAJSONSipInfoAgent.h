//
//  SAJSONSipInfoAgent.h
//  AuroraPhone
//
//  Created by Melo Yao on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONHttpAgent.h"
#import "SABizProtocols.h"

@class SipInfo;
@class videoproxyModel;
@class jabberprofileModel;

@interface SAJSONSipInfoAgent : SAJSONHttpAgent<SASipInfoProtocol>

@property(nonatomic,retain) videoproxyModel* videoproxyModel;

@property(nonatomic,retain) jabberprofileModel* jabberprofileModel;

@property(nonatomic,retain) SipInfo *sipInfo;

@property(nonatomic,retain) NSString *targetAppVersion;
@end
