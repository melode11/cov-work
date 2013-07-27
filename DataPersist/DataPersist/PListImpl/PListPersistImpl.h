//
//  PListPersistUtility.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersistImpl.h"

@interface PListPersistImpl : NSObject<PersistImpl>
{
    @private
    NSString *_basePath;
}

-initWithPath:(NSString*)basePath;

@end
