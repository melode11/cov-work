//
//  UrlSplliter.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "UrlSplitter.h"

void splitUrl(NSString* url, UrlSplitResult* outResult)
{
    NSRange range = [url rangeOfString:@"://"];
    if(range.length>0)
    {
        outResult->scheme = [url substringToIndex:range.location];
        outResult->ip = [url substringFromIndex:range.location+range.length];
    }
    else {
        outResult->scheme = @"http";
        outResult->ip = url;
    }
}