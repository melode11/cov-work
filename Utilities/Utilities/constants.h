/*
 Copyright (c) 2007-2011, GlobalLogic Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list
 of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or other
 materials provided with the distribution.
 Neither the name of the GlobalLogic Inc. nor the names of its contributors may be
 used to endorse or promote products derived from this software without specific
 prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 OF THE POSSIBILITY OF SUCH DAMAGE."
 */

// Request Parameters - kUserRegistrationRRT (0001)

#define kRequestType                    @"RT"
#define kDeviceType                     @"DT"
#define kUDID                           @"UDID"
#define kPacketVersion                  @"PV"
#define kPlatformVersion                @"PF"
//extra parameter required for FreeHand Drawing
#define kTag                            @"TAG"
//extra parameter required for Authentication
#define kLatitude                       @"LAT"
#define kLongitude                      @"LON"
#define kLocation                       @"LOC"
#define kServiceType                    @"ST"
#define kUserName                       @"UN"
#define kPassword                       @"PW"
//extra parameter required for PushNotification
#define kPushNotification               @"APNS"
#define kXMPPNotification               @"XMPPNotification"
#define kSessionServerNotification      @"SessionServerNotification"
#define kJabberSettings                 @"myJabberSetting"
#define kPopToRootViewController        @"PopToRootViewController"
#define kBadBandwidth                   @"Bandwidth is too low"
//exra parameter if self check is enabled
#define	kSelfCheck                      @"SC"
//extra parameter for annotation
#define	kContentType                    @"Content-type"
// HTTP service type GET or POST
#define kHttpRequestType                @"RequestType"

#define kPOST                           @"POST"
#define kGET                            @"GET"
#define MINBANDWIDTH                    190
#define VIDEOBANDWIDTH                  250
#define __SHOWALERT__                   @"1"

#define kVideoMINBandWidthValue         @"190"
#define kVideoRestartBandWidthValue     @"250"
#define kVideoQualityValue              @"30"
#define kCameraQualityValue             @"1"//Medium preset
#define kLowbandWidthValue                   @"0"

// Video Setting Macros
#define kMinimumBWRequired              @"MBWR"
#define kMinimumBWRequiredToResatrt     @"MBWRToRestart"
//#define kLastReceivedbandWidth        @"LastReceivedBandwidth"
#define kShowAlert                      @"ShowAlert"
#define kVideoIP                        @"VideoServerURLAndIP"
#define kVideoQualityKey                @"VideoQuality"
#define kCameraQualtiyKey               @"CameraQuality"

#define kLastBandWidth                  @"0.0"

//Niotifications
#define kLowBandWidthNotification       @"LowBandWidthNotification"
#define kBackFromTheCameraControl       @"BackFromCameraControl"	
#define kMakeCallFromCameraController   @"MakeCallFromCameraControl"
#define kEndCallFromCameraController    @"kEndCallFromCameraController"
#define kSnapShotController             @"CaptureSnapShot"
#define kXMPPDisconnected               @"XMPPDisconnected"
#define kClientDisconnected             @"ClientDisconnected"
#define kVideoNotificationKey           @"VideoNotification"
#define kFreezeResponse                 @"FreezeResponse"
#define kFreezeIntent                   @"FreezeIntent"
#define kFreezeRequest                  @"FreezeRequest"
#define kAudioCall						@"AudioCall"
#define kVideoCall						@"VideoCall"
#define kUnFreezeResponse               @"UnFreezeResponse"
#define kSnapShot                       @"SnapShot"
#define kAnnotationsAdd					@"AnnotationsAdd"
#define kAnnotationsDelete				@"AnnotationsDelete"

#define kSIPReadyForNextCall            @"SIPReadyForNextCall"

//call after tap.add by kuison
#define kMakeSelectCall                 @"MakeSelectCall"
//end of add

// Registration successfully done - Themis
#define kRegistrationDone           @"RegistrationDone"

//Internet connection status notifications
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"
#define kLostConnection					@"LostConnection"
#define kRecoveryConnection				@"RecoveryConnection"
#define kChangeConnectionStatus			@"ChangeConnectionStatus"
#define kNeedRelogin               @"NeedRelogin"

#define kConflictLogin			        @"conflictLogin"

#define kAppRelaunchedFromBackgroundMode @"ApplicationRelaunchedFromBackgroundMode"

#define kMissedCallUpdated        @"MissedCallUpdated"

//NavigationController
#define kPopNavigationController        @"PopNavigationController"

//For SIP ID
#define kCSRSupportPersonID             @"CSRSupportID"
#define kTSRSupportID                   @"TSRSupportID"
#define kIP                             @"IP"
#define kPORT                           @"PORT"	
#define kForceSettings                  @"ForceSettings"	
#define	kSIPUserName                    kUserName
#define kSIPPassword                    kPassword
#define kShowDebugMessage               @"ShowDebugMessage"
#define kStunConfigration               @"StunConfigatrion"
#define kSIPAuthUserName                @"SIPAuthUserName"


#define kUserAutheticated               @"UserAuthenticated"
//! For run video restart prcess notification
#define kRunVideoRestartProcess         @"kRunVideoRestartProcess"


#define kJabberVirtualHost              @"JabberVirtualHost"
#define kJabberIP                       @"JabberIP"
#define kJabberPort                     @"JabberPort"
#define kJabberPassword                 @"JabberPassword"
#define kjabberID                       @"jabberID"

#define kStopSendingFrames              @"StopSendingFrames"
#define kStartSendingFrames             @"StartSendingFrames"
#define kVideoCallEnd                   @"VideoCallEnd"

#define kEndCallFromVideoSupport        @"EndCallFromVideoSupport"
#define kEndCallFromVideoiPhoneSupport        @"EndCallFromVideoiPhoneSupport"
#define kLowbandWidth                   @"kLowbandWidth"

#define kEnhancedSnapshotRequired       @"EnhancedSnapshot"
#define kUnFreezeVideo                  @"UnFreezeVideo"
#define kReloadVideo                    @"ReloadVideo"
#define kFreezeStatusFromSupport        @"FreezeStatusFromSupport"
#define kFreezeSetViewStates            @"FreezeSetViewStates"

#define kStartVideo                     @"StartVideo"
#define kStartSIPCall                   @"StartSIPCall"

//Added by Hank
#define kToggleVideoFromRequest         @"ToggleVideoFromRequest"
#define kToggleVideoFromResponse        @"ToggleVideoFromResponse"
#define kToggleVideoCancelled           @"ToggleVideoCancelled"
#define kToggleVideoTimeout             @"ToggleVideoTimeout"
#define kToggleVideoExpiredResponse     @"ToggleVideoExpiredResponse"
//iPad notify video connection --Hank
//#define kVideConnected                  @"VideoConnected"

#define kDidFailRegistering             @"DidFailRegistering"
//Menu switch by hand during call. add by kuison
#define kSwitchVideoOn                      @"SwitchVideoOn"
#define kSwitchVideoOff                     @"SwitchVideoOff"
//end of add

//ipad placed call --cuckoo
#define kHideAVSwitch               @"HideAVSwitch"
#define kFileTransfer               @"FileTransfer"
//end --cuckoo

#define kStopViewingTheSnapShotFromOtherDevice @"StopViewingTheSnapShot"
#define kSnapShotReceived              @"SnapShotReceived"
#define kSendCapturedImageToSupport    @"SendCapturedImageToSupport"    
#define kFreezedImageFromSupport        @"FreezedImageFromSupport"
#define kFreezedImageFromLocal          @"kFreezedImageFromLocal"

#define kFreezedImage @"freezedImage"
#define kFreezedOrientation @"freezedOrientation"
#define kFreezeEvent @"freezeEvent"
// File received
#define kFileReceived                   @"FileReceived"

// SA2 Interface
#define kSA2FileReceived @"SA2FileReceived"

//! Macro used for sending snap shot to support implementation
#define kSnapShotSendStatus                @"SnapShotSendStatus"
#define kSnapShotSendSuccess               @"SnapShotSendSuccess"
#define kSnapShotSendFail                  @"SnapShotSendFail"
#define kRemoveSendSnapShotToSupportView   @"kRemoveSendSnapShotToSupportView"
#define kSnapshotSendingFailed              @"0"
#define kSnapShotSendingSuccess             @"1"

//Added By Hank
//Notification, ask remote phone call back
#define kCallBackRequest                                @"CallBackRequest"

//Notification to CSAnnotationviewcontroller to Enable/Disable Video button
#define kDisableVideoButton     @"DisableVideoButton"
#define kEnableVideoButton      @"EnableVideoButton"

//This key and secret is for Covidien Provision file instead of Global Logic one
// Modify for new NotiApp
// Covidien Key
//#define kiPadDevelopmentApplicationKey                  @"4JHaI56NRF6IPu4yR81qTg"
//#define kiPadDevelopmentApplicationSecret               @"c1BEpLPOQ3mXgySeGQy5CA"
//#define kiPadDevelopmentApplicationMasterSecret         @"2t3Twn0VSgeK9BqNJgVW2A"
//
//#define kiPadDistributionApplicationKey                 @"-YJKEHhASWylxLYc7KVvvg"
//#define kiPadDistributionApplicationSecret              @"TWoCXcBjR4CKRw1hGkCsvw"
//#define kiPadDistributionApplicationMasterSecret        @"WDneBxC_SmmKFMGM-FQgcQ"
//
//#define kiPhoneDevelopmentApplicationKey                @"vGugHMAMRd6qOswrGVCV2Q"
//#define kiPhoneDevelopmentApplicationSecret             @"TmvVveswQGSWqCB7vGAuYw"
//#define kiPhoneDevelopmentApplicationMasterSecret       @"N8P-taP2RyyFrLHGNSzBuw"
//
//#define kiPhoneDistributionApplicationKey               @"kxd_Ln6wRGqYFI9gm0lAog"
//#define kiPhoneDistributionApplicationSecret            @"NWH_VhVlTMmy0YOx4yyy9Q"
//#define kiPhoneDistributionApplicationMasterSecret      @"UN7yQA9lRKu2Wz5qwPlFFQ"
// Covidien Key

// GL Dev Key
//#define kiPadDevelopmentApplicationKey                  @"dr7dN8ENQgSrvr3Zi7ke9g"
//#define kiPadDevelopmentApplicationSecret               @"KxjkiXarT9G6W4SwMMVTzw"
//#define kiPadDevelopmentApplicationMasterSecret         @"6M9_9EtjTZWvPMYA2CW5JA"
//
//#define kiPadDistributionApplicationKey                 @"-YJKEHhASWylxLYc7KVvvg"
//#define kiPadDistributionApplicationSecret              @"TWoCXcBjR4CKRw1hGkCsvw"
//#define kiPadDistributionApplicationMasterSecret        @"WDneBxC_SmmKFMGM-FQgcQ"
//
//#define kiPhoneDevelopmentApplicationKey                @"t9F-WTgTTt63wUVkKjUP2w"
//#define kiPhoneDevelopmentApplicationSecret             @"uOirlVdARjuIrmtAmEST6w"
//#define kiPhoneDevelopmentApplicationMasterSecret       @"NJh_hb6YRpy93A-aRBPKPw"
//
//#define kiPhoneDistributionApplicationKey               @"kxd_Ln6wRGqYFI9gm0lAog"
//#define kiPhoneDistributionApplicationSecret            @"NWH_VhVlTMmy0YOx4yyy9Q"
//#define kiPhoneDistributionApplicationMasterSecret      @"UN7yQA9lRKu2Wz5qwPlFFQ"
// GL Dev Key

//add by kuison for new provision
//#define kiPhoneDevelopmentApplicationKey                @"UsLWJ0u3QXyXm1uATaSjCw"
//#define kiPhoneDevelopmentApplicationSecret             @"LsGeF8NDRVO051MzOcxrvQ"
//#define kiPhoneDevelopmentApplicationMasterSecret       @"w21aq30sTlmTcg2tTXXkJQ"
//
//#define kiPadDevelopmentApplicationKey                  @"623TqqNoQCqO3eGP41249g"
//#define kiPadDevelopmentApplicationSecret               @"ltWCL3UrS5qmJPwzbnbPfQ"
//#define kiPadDevelopmentApplicationMasterSecret         @"KnUQHMqYQg2NacJv7V-sYg"
//
//#define kiPhoneDistributionApplicationKey               @"Rhe2iVKXS8-5Ahlq5vZ2kw"
//#define kiPhoneDistributionApplicationSecret            @"UClbrPXoQgue4yU_h3cdBw"
//#define kiPhoneDistributionApplicationMasterSecret      @"E1w3MyBMTw2ArMzVWOpDOg"
//
//#define kiPadDistributionApplicationKey                 @"6Gy_3y81R0aExCo1gP5S4w"
//#define kiPadDistributionApplicationSecret              @"MSqRosk1Shi_9-YhRpsQbA"
//#define kiPadDistributionApplicationMasterSecret        @"EU-pRyTJQlSsjtgPvdZr6A"
//end of add

// com.shanghai.helpsource.*
#define kiPhoneDevelopmentApplicationKey                @"Pa1LK73mQlioyEk_hIVvBA"
#define kiPhoneDevelopmentApplicationSecret             @"Au26N-y7SW6zCDSnUA8v5Q"
#define kiPhoneDevelopmentApplicationMasterSecret       @"hAmZkZmvQuuuD9FNfo62IA"

#define kiPadDevelopmentApplicationKey                  @"jCpHHk04ToiyYk6ek98Zsw"
#define kiPadDevelopmentApplicationSecret               @"MZjrqOHKQrSIih4TKZgm_w"
#define kiPadDevelopmentApplicationMasterSecret         @"rzof30icSxSNRUw3HCJPew"

#define kiPhoneDistributionApplicationKey               @"OPmbVdjhQtOVoqZNvEdWqw"
#define kiPhoneDistributionApplicationSecret            @"MLXjKGaHThWvjLCRHE8hyQ"
#define kiPhoneDistributionApplicationMasterSecret      @"AQEMdVKbSLKSwHiUMNeqGw"

#define kiPadDistributionApplicationKey                 @"L-5RwWbDSUGSrmxsDMmApA"
#define kiPadDistributionApplicationSecret              @"HY0Em9hHQLmpY6ETxUFnmQ"
#define kiPadDistributionApplicationMasterSecret        @"-PXvr0a9SDOjW1HhL8gJ3Q"
// com.shanghai.helpsource.*


// com.covidien.auroraii
#define kDevelopmentApplicationKey                      @"2AHIYqlIS06k_DmXixMRPg"
#define kDevelopmentApplicationSecret                   @"kwrMxqC2S8CWXOQeyMt3Rw"
#define kDevelopmentApplicationMasterSecret             @"oAsEcNlbTW-6N1luEI0rbw"

#define kDistributionApplicationKey                     @"wxhXJWQkTl6jyckZAGJ24w"
#define kDistributionApplicationSecret                  @"2p2YB_bQS5GZ1BPtg2eM-A"
#define kDistributionApplicationMasterSecret            @"vsQ4dXxJR-eEw6ji1P-3og"

//Sip Information//

//sip Gate Jim Power
// CSR SIP settings
//#define SIP_SERVER_IP                 	@"sipgate.com"
//#define SIP_PORT                      	@"80"
//#define SIP_USER_IPAD                 	@"1273694e0"
//#define SIP_USER_IPHONE					@"1273700e0"
//#define SIP_PASSWORD_IPAD				@"EGSH9R"
//#define SIP_PASSWORD_IPHONE           	@"4H5DYU"
//#define SIP_SUPPORT_ID                	@"1273694e0"
//

//OnSip sip info
#define SIP_SERVER_IP                 	@"raju1.onsip.com"
#define SIP_PORT                      	@"80"

#define SIP_USER_IPHONE					@"iphone"
#define SIP_USER_IPHONE_AUTHNAME        @"raju1"
#define SIP_PASSWORD_IPHONE           	@"JckM2SxwGM9RctZm"
#define SIP_SUPPORT_ID                	@"ipadcsr" // CSR
#define SIP_SUPPORT_ID_USER2            @"ipadtsr" // TSR

// CSR SIP authorization information
#define SIP_USER_IPAD                 	@"ipadcsr"
#define SIP_USER_IPAD_AUTHNAME          @"raju1_raju0473_1"
#define SIP_PASSWORD_IPAD				@"sLbKc88P65F4Tehg"

//TSR SIP authorization information
#define SIP_USER_IPAD_USER2             @"ipadtsr"
#define SIP_PASSWORD_IPAD_USER2			@"t8C8nsQpaHYsBnpW"
#define SIP_USER_IPAD_AUTHNAME_USER2    @"raju1_raju1_p_jha"

//sip Gate Scott Licursi
//#define SIP_SERVER_IP                 	@"sipgate.com"
//#define SIP_PORT                      	@"80"
//#define SIP_USER_IPAD                 	@"1272314e0"
//#define SIP_USER_IPHONE					@"1272323e0"
//#define SIP_PASSWORD_IPAD				@"WQVF6N"
//#define SIP_PASSWORD_IPHONE           	@"SEVYNB"
//#define SIP_SUPPORT_ID                	@"1272314e0"


//Callcentric Klavdiia
//#define SIP_SERVER_IP                 @"callcentric.com"
//#define SIP_PORT                      @"80"
//#define SIP_USER_IPAD                 @"17772043992"
//#define SIP_USER_IPHONE               @"17772188905"
//#define SIP_PASSWORD_IPAD             @"g00gl3"
//#define SIP_PASSWORD_IPHONE           @"g00gl3"
//#define SIP_SUPPORT_ID                @"17772043992"

//James iPhone< james iPad
//
/*
#define SIP_SERVER_IP                   @"callcentric.com"
#define SIP_PORT                        @"80"
#define SIP_USER_IPAD                   @"17772915306"
#define SIP_USER_IPHONE                 @"17772704008"
#define SIP_PASSWORD_IPAD               @"12qwaszx"
#define SIP_PASSWORD_IPHONE             @"12qwaszx"
#define SIP_SUPPORT_ID                  @"17772915306"
*/
//scott iphone<scot iPad

//#define SIP_SERVER_IP                 @"callcentric.com"
//#define SIP_PORT                      @"80"
//#define SIP_USER_IPAD                 @"17772699773"
//#define SIP_USER_IPHONE               @"17772268132"
//#define SIP_PASSWORD_IPAD             @"12qwaszx"
//#define SIP_PASSWORD_IPHONE           @"12qwaszx"
//#define SIP_SUPPORT_ID                @"17772699773"

#define SIP_FORCELOGIN                  @"1"
#define SIP_STUNCONFIGRATION            @"0"

#ifdef _DEBUG
    //amazon Test Server
    #define kJabberServerIP				@"27.109.106.216"
    #define kJabberServerVirtualHost	@"ejabbercov.com"
    //Test video Server
    #define kDefaultServer_iPad			@"27.109.106.216:12340"
    #define kDefaultServer_iPhone		@"27.109.106.216:12350"
    
	//File server
    #define kDOC_FILE_SERVER            @"http://27.109.106.216"
	#define DOC_SEND_URL                @"http://27.109.106.216/fusample.php?udid=%@&fname=%@"
    #define kRegistrationServerURL      @"http://27.109.106.216/aurora/userinfo/"
    #define kSessionServerIP            @"27.109.106.216"
    
#else
	//amazon Production server
    #define kJabberServerIP				@"aurora.covidien.com"
    #define kJabberServerVirtualHost	@"aurora.covidien.com"
    //Test video Server
    #define kDefaultServer_iPad			@"aurora.covidien.com:32340"
    #define kDefaultServer_iPhone		@"aurora.covidien.com:32350"
	//File server
    #define kDOC_FILE_SERVER            @"http://aurora.covidien.com"
	#define DOC_SEND_URL                @"http://aurora.covidien.com/fusample.php?udid=%@&fname=%@"
    #define kRegistrationServerURL      @"http://aurora.covidien.com/aurora/userinfo/"
    #define kSessionServerIP            @"https://aurora-us1.b4d.com.srip.net"
#endif

#define kSS_SIPID_INFO_URl          @"%@://%@/aurora/sipinfo.json?sipid=%@"
#define kDefaultCalibrationServerPort		@"12357"

#define kjabberIDValue                  @"0"
#define kJabberServerPort               @"5222"
#define kJabber_Password_IPHONE         @"#ADP321@cigollabolg"
#define kJabber_Password_IPAD           @"#ADP321@cigollabolg"

#define __Password_                     @"#ADP321@cigollabolg"
#define kTouchNotify                    @"TouchBeginWebView"

#define kjabberprofileModel @"jabberprofileModel"
#define kfileserverModel    @"fileserverModel"
#define ksipprofileModel    @"sipprofileModel"
#define kvideoproxyModel    @"videoproxyModel"
#define kudidModel          @"udidModel"
#define kuinfoModel         @"uinfoModel"
#define ksupportsipprofilesModel    @"supportsipprofilesModel"

#define DEVICENAME_IPAD @"iPad"
#define DEVICENAME_IPHONE @"iPhone"

//! Signal server 
typedef enum
{
    IN_CALL_SIGNAL         = 1<<0,
    FREEZE_SIGNAL          = 1<<1,
    FROZEN_SIGNAL          = 1<<2,
    ANNOTATION_SIGNAL      = 1<<3,
    END_CALL_SIGNAL        = 1<<4,//!End call signal to terminate call instantly
    FILE_UPLOAD_SIGNAL     = 1<<5,
    UNFREEZE_SIGNAL        = 1<<6,
    AUDIO_ONLY_SIGNAL      = 1<<7,//!During low bandwidth only audio signal
    VIDEO_CALL_SIGNAL      = 1<<8,//!Sufficient bandwidth available then video signal
    PRESENCE_SIGNAL        = 1<<9
    
}Signals;

typedef enum
{
    MAX_C2S = 63
}SignalCatagory_C2S;

typedef enum
{
    MAX_S2C = 127
}SignalCatagory_S2C;

typedef enum
{
    MAX_C2C = 255
}SignalCatagory_C2C;

//! Different AlertTags
#define kNetwrokLostAlertTag                5001
#define kHTTPConnectionFailedAlertTag       5002
#define kEraseAllAnnotationsAlertTag		5003
#define kRetryWaitForFreezeAlertTag         5004
#define kRetryFileSendAlertTag              5005
#define kJabberMismatchAlertTag             5006
#define kRemoveAnnotationAlertTag           5007
#define kFreezeFailedAlertTag               5008
#define kMaxFileAlertTag                    5009
#define kSessionServerIPErrorAlertTag       5010
#define kSipPartnerInfoErrorAlertTag        5011

//user defaults key
#define kSessionServerIPKey @"sessionServerIP"
#define kSessionServerIPCompareKey @"sessionServerIPCompare"

// CRMOD function - Themis
#define CRMOD_RECORD_PATH @"CRMOD"
#define CRMOD_CALL_LOG_FILE @"CRMOD_log.plist"