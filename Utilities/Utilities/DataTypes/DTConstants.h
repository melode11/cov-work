//
//  DTConstants.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef Annotation_iPad_DTConstants_h
#define Annotation_iPad_DTConstants_h

typedef enum {
    eSecureNone = 0,
    eSecureRsaToken = 1
} SecureType;


#define kContactId @"id"

#define kContactName @"username"

#define kContactFirstName @"firstname"

#define kContactLastName @"lastname"

#define kContactDeviceTye @"devicetype"

#define kContactType @"type"

#define kContactIsDefault @"isdefault"

#define kContactIsShortcut @"isshortcut"

#define kContactDisplayName @"display_name"

#define kProductGroupId @"groupid"

#define kProductGroupName @"groupname"

#define kClientFeatureName @"name"

#define kClientFeatureCode @"code"

#define kClientFeatureDescription @"description"

#define kClientFeatureVersion @"version"

#define kClientFeatureParameters @"parameters"

#define kSa2ProfileCode @"code"

#define kSa2ProfileName @"name"

#define kUserProfileId @"userId"

#define kUserProfileName @"name"

#define kUserProfileDisplayName @"display_name"

#define kUserProfileDeviceType @"devicetype"

#define kUserProfileProductGroup @"productgroup"

#define kRemoteFileId @"fileId"

#define kRemoteFileName @"filename"

#define kRemoteFileRemotePath @"fullpath"

#define kSipInfoName @"name"

#define kSipInfoSupportType @"supporttype"

#define kSipInfoDeviceName @"devicename"

#define kHistoryRecordId @"id"

#define kHistoryRecordType @"type"

#define kHistoryRecordPeerId @"peerid"

#define kHistoryRecordPeerDisplayName @"displayName"

#define kHistoryRecordPeerDeviceType @"devicetype"

#define kHistoryRecordTime @"time"

// AURORA-1712
#define kHistoryRecordCallId @"callid"

#define kCrmodCallerId @"id"

#define kCrmodCallerFlag @"CRMODFlag"

#define kCrmodCallerEndTime @"EndTime"

#define kCrmodCallerName @"Name"

#define kCrmodCallerStartTime @"StartTime"

#define kCrmodCallerType @"Type"

#define kServerModelHost @"host"

#define kServerModelPath @"path"

#define kServerModelPort @"port"

#define kServerModelProtocol @"protocol"

#endif
