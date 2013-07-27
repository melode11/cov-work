//
//  SAv2ServiceLocator.h
//  ServerAgents
//
//  Created by Yao Melo on 7/18/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAConstants.h"
#import "SABizProtocols.h"

@interface SAv2ServiceLocator : NSObject<SAServiceLocator>

@property (nonatomic,retain) NSString* baseUrl;

@end
