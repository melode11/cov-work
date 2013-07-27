//
//  SAJSONUserInfoAgent.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONHttpAgent.h"
#import "SABizProtocols.h"

@class videoproxyModel;
@class fileserverModel;
@class sipprofileModel;
@class jabberprofileModel;
@class UserProfile;

@interface SAJSONUserInfoAgent : SAJSONHttpAgent<SAUserInfoProtocol>
{
    @private
    NSArray* _features;
    NSArray* _sa2Profiles;
}

@property (nonatomic,retain) UserProfile* userProfile;

@property (nonatomic,retain) videoproxyModel* videoproxyModel;

@property (nonatomic,retain) fileserverModel* fileserverModel;

@property (nonatomic,retain) sipprofileModel* sipprofileModel;

@property (nonatomic,retain) jabberprofileModel* jabberprofileModel;

@property (nonatomic,retain) NSArray* supportsipprofilesModelArray;

@end
