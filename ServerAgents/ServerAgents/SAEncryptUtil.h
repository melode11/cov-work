//
//  SARsaUtil.h
//  Test
//
//  Created by Yao Melo on 4/16/13.
//  Copyright (c) 2013 Yao Melo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAConstants.h"

@interface SAEncryptUtil : NSObject

+(NSString *)tokenWithSecureType:(SASecureType)type secureKey:(NSString*)key name:(NSString *)loginname time:(NSNumber *)timeNum deviceType:(NSString *)deviceType version:(NSString *)appVersion;


@end
