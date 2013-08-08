//
//  Contact.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  USER_CONTACT 1
#define  GROUP_CONTACT 2

@interface Contact : NSObject

@property (nonatomic,assign) NSInteger contactId;

@property (nonatomic,retain) NSString* name;

@property (nonatomic,retain) NSString *displayName;

@property (nonatomic) NSInteger type;

@property (nonatomic, assign) NSInteger missedMsgCount;

@end
