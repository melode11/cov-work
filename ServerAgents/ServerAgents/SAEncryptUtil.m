//
//  SARsaUtil.m
//
//  Created by Yao Melo on 4/16/13.
//  Copyright (c) 2013 Yao Melo. All rights reserved.
//

#import "SAEncryptUtil.h"
#import "Utilities/RsaUtil.h"
#import "Utilities/Base64EncoderDecoder.h"
#import <SBJson.h>


@implementation SAEncryptUtil


+(NSString *)tokenWithSecureType:(SASecureType)type secureKey:(NSString*)key name:(NSString *)loginname time:(NSNumber *)timeNum deviceType:(NSString *)deviceType version:(NSString *)appVersion
{
    DDLogVerbose(@"Encrypt with type:%d using key:%@",type,key);
    if (type == eSecureRsaToken) {
        NSString *rawToken = [[NSDictionary dictionaryWithObjectsAndKeys:loginname,@"name",timeNum,@"time",deviceType,@"device",appVersion,@"ver", nil] JSONRepresentation];
        DDLogInfo(@"Raw token for encrypt:%@",rawToken);
        NSString* cipherText = [[RsaUtil encryptWithPublicKey:[NSData dataFromBase64String:key] forData:[rawToken dataUsingEncoding:NSUTF8StringEncoding]] base64EncodedString];
        DDLogVerbose(@"Encrypted text:%@",cipherText);
        return cipherText;
    }
    //insert other secure model types here in future.
    return nil;
}


@end
