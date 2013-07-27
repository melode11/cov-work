//
//  RemoteFile.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteFile : NSObject

@property (nonatomic,assign) NSInteger fileId;

@property (nonatomic,retain) NSString* remotePath;

@property (nonatomic,retain) NSString* name;

@end
