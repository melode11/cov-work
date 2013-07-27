//
//  SABizProtocols.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef Annotation_iPad_SABizProtocols_h
#define Annotation_iPad_SABizProtocols_h
#import "SAConstants.h"

FOUNDATION_EXPORT NSString *const SERVICE_PHONEBOOK;
FOUNDATION_EXPORT NSString *const SERVICE_PRODUCTGROUP;
FOUNDATION_EXPORT NSString *const SERVICE_USERINFO;
FOUNDATION_EXPORT NSString *const SERVICE_EXTRAINFO;
FOUNDATION_EXPORT NSString *const SERVICE_WEBAUTHENTICATE;
FOUNDATION_EXPORT NSString *const SERVICE_FILEUPLOAD;
FOUNDATION_EXPORT NSString *const SERVICE_SIPINFO;
FOUNDATION_EXPORT NSString *const SERVICE_CRMODUPLOAD;
FOUNDATION_EXPORT NSString *const SERVICE_APPVERSION;
FOUNDATION_EXPORT NSString *const SERVICE_SECUREMODEL;

// AURORA-1712
FOUNDATION_EXPORT NSString *const SERVICE_UPLOADMC;
FOUNDATION_EXPORT NSString *const SERVICE_DOWNLOADMC;
FOUNDATION_EXPORT NSString *const SERVICE_CONFIRMMC;
FOUNDATION_EXPORT NSString *const SERVICE_CLEARMC;

FOUNDATION_EXPORT NSString *const SERVICE_LOGIN;
FOUNDATION_EXPORT NSString *const SERVICE_USERLIST;


@class videoproxyModel;
@class fileserverModel;
@class sipprofileModel;
@class jabberprofileModel;
@class supportsipprofilesModel;
@class RemoteFile;
@class SipInfo;
@class UserProfile;
@class ServerModel;

@protocol SAPhoneBookProtocol <ServerAgentProtocol>

-(void)requestPhoneBook:(NSString *)timestamp withLoginname:(NSString*)loginName;

-(NSArray*) getContacts;

-(NSString*) getTimestamp;

-(BOOL)isUpdated;

@end

@protocol SAProductGroupProtocol <ServerAgentProtocol>

-(void)requestGroups;

-(NSArray*)getGroups;

@end

@protocol SAUserInfoProtocol <ServerAgentProtocol>

-(void)requestUserInfo:(NSString*) loginName group:(NSString*) groupId;

//extend the userinfo usage for version upload.
-(void)requestUserInfo:(NSString *)loginName group:(NSString *)groupId version:(NSString*) appVersion versionChanged:(BOOL)isChanged;

//extra info is combined with features and sa2 profiles.
-(void)requestExtraInfo:(NSString*) loginName;

-(NSArray*)features;

-(NSArray*)sa2Profiles;

-(UserProfile*) userProfile;

-(videoproxyModel*)videoproxyModel;

-(fileserverModel*)fileserverModel;

-(sipprofileModel*)sipprofileModel;

-(jabberprofileModel*)jabberprofileModel;

-(NSArray*)supportsipprofilesModelArray;

@end

@protocol SAWebAuthenticateProtocol <ServerAgentProtocol>

-(void)requestWebAuthenticateWithUsername: (NSString*) username password:(NSString*)password;

@end

@protocol SAFileUploadProtocol <ServerAgentProtocol>

-(void)requestUploadWithPath:(NSString *)fullPath andLoginName:(NSString*) loginname;

-(void)requestUploadWithData:(NSData *)data andFilename:(NSString*) filename loginName:(NSString*) loginname;

-(void)requestUploadCRMODWithPath:(NSString *) fullPath andLoginName:(NSString*) loginname;

-(RemoteFile*)remoteFile;

-(NSString*) localFilePath;

-(BOOL)isStopped;

/*
 * Thread-safe to call this
 */
-(void)stopSending;

@end


@protocol SASipInfoProtocol <ServerAgentProtocol>

-(void)requestSipInfo:(NSString*) sipId;

-(jabberprofileModel*)jabberprofileModel;

-(videoproxyModel*)videoproxyModel;

-(SipInfo*)sipInfo;

-(NSString*)targetAppVersion;
@end

@protocol SAAppVersionProtocol <ServerAgentProtocol>

-(void)postAppVersion:(NSString *)versionNumber withLoginname:(NSString*) loginName;

@end

@protocol SASecureModelProtocol <ServerAgentProtocol>

-(void)requestSecureModelWithName:(NSString*) loginname version:(NSString*)clientVersion;

-(SASecureType) secureType;

-(NSString*) secureEncryptKey;

-(NSTimeInterval) secureKeyTime;

-(NSString*) secureToken;

-(BOOL)secureAllowFallback;

@end

// AURORA-1712
@protocol SAMissedCallProtocol <ServerAgentProtocol>

-(void)uploadMissedCall:(NSString*) caller to:(NSString*)receiver accepted:(NSString*)acceptor;

-(void)downloadMissedCall:(NSString*)receiver;

-(void)confirmMissedCallDownloaded:(NSString*)receiver;

-(void)clearMissedCallRecord:(NSString*)receiver;

-(NSArray*)getMissedCallArray;

@end

@protocol SALoginProtocol <ServerAgentProtocol>

- (NSString*) token;
- (ServerModel*) messagingServer;
- (NSString*) userName;
- (NSString*) displayName;
- (NSInteger) userId;

-(void) requestLoginWithName:(NSString*)username password:(NSString*)psw;

@end

/**
 * This is similar with phone book protocol, but the input/output is not exactly the same,
 * So to minimize confusion, we used a new protocol here.
 */
@protocol SAUserListProtocol <ServerAgentProtocol>

-(void) requestUserListWithToken:(NSString*)loginToken;

-(NSArray*) contacts;

-(NSDictionary*) statusMapping;

-(NSDictionary*) activeDevicesMapping;

-(unsigned long long)timestamp;

@end

#endif
