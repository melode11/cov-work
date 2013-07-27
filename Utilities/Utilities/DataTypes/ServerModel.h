//
//  ServerModel.h
//  Utilities
//
//  Created by Yao Melo on 7/23/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerModel : NSObject
@property(nonatomic, retain)     NSString *host;
@property(nonatomic, retain)     NSString *path;
@property(nonatomic, assign)     NSInteger port;
@property(nonatomic, retain)     NSString *protocol;
@end
