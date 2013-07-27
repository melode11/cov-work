//
//  SAJSONSecureModelAgent.h
//  Annotation_iPad
//
//  Created by Yao Melo on 4/17/13.
//
//

#import "SAJSONHttpAgent.h"
#import "SABizProtocols.h"

@interface SAJSONSecureModelAgent : SAJSONHttpAgent<SASecureModelProtocol>
{
    long long _secureKeyTimeMillis;
    NSString *_loginName;
    NSString *_appVersion;
    NSString *_deviceType;
}

@property(nonatomic,readonly) NSString* secureEncryptKey;

@property(nonatomic,readonly) NSTimeInterval secureKeyTime;

@property(nonatomic,readonly) SASecureType secureType;

@property(nonatomic,readonly) NSString* secureToken;

@property(nonatomic,readonly) NSString* secureAllowFallback;

@end
