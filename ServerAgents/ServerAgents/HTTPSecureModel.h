//
//  HttpSecureModel.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFUALT_SESSION_USER @"aurora"
#define DEFUALT_SESSION_PWD @"aurora@covidien"

@interface HTTPSecureModel : NSObject

@property (retain,nonatomic) NSString *user;

@property (retain,nonatomic) NSString *password;

@end
