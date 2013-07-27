//
//  DAOManager.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PhoneBookDAO;
@class ClientFeatureDAO;
@class UserProfileDAO;
@class ServerSettingDAO;
@class Sa2DAO;
@class CallHistoryDAO;
@class CrmodCallerDAO;
@class AppVersionDAO;
@class SecurityDAO;

@interface DAOManager : NSObject
{
    PhoneBookDAO* _phonebookDAO;
    ClientFeatureDAO* _clientFeatureDAO;
    UserProfileDAO* _userProfileDAO;
    ServerSettingDAO* _serverSettingDAO;
    Sa2DAO *_sa2DAO;
    CallHistoryDAO* _callHistoryDAO;
    CrmodCallerDAO *_crmodCallerDAO;
    AppVersionDAO *_appVersionDAO;
    SecurityDAO *_securityDAO;
}

@property(readonly) PhoneBookDAO* phoneBookDAO;

@property(readonly) ClientFeatureDAO* clientFeatureDAO;

@property(readonly) UserProfileDAO* userProfileDAO;

@property(readonly) ServerSettingDAO* serverSettingDAO;

@property(readonly) Sa2DAO *sa2DAO;

@property(readonly) CallHistoryDAO *callHistoryDAO;

@property(readonly) CrmodCallerDAO *crmodCallerDAO;

@property(readonly) AppVersionDAO *appVersionDAO;

@property(readonly) SecurityDAO *securityDAO;

+(DAOManager*) sharedInstance;

@end
