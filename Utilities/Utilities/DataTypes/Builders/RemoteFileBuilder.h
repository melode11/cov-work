//
//  RemoteFileBuilder.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteFile.h"

@interface RemoteFileBuilder : NSObject

+(RemoteFile*) buildFromDict:(NSDictionary*) dic;

+(NSDictionary*) toDictionary:(RemoteFile*) file;

@end
