//
//  UrlSplitter.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSString.h>

typedef struct UrlSplitResult
{
    NSString *scheme;
    NSString *ip;
} UrlSplitResult;

inline void splitUrl(NSString* url, UrlSplitResult* outResult);