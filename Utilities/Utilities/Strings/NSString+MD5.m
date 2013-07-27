//
//  NSString+MD5.m
//  Utilities
//
//  Created by Yao Melo on 7/18/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "NSString+MD5.h"
#import <tomcrypt.h>

#define MD5_LEN 16
const char* const hex = "0123456789abcdef";

@implementation NSString (MD5)

-(NSString *)md5Value
{
    const char* inData = [self UTF8String];
    int maxLen = strlen(inData);
    
    unsigned char outdata[MD5_LEN];
    //reinterpret cast
    
    hash_state md;
    md5_init(&md);
    md5_process(&md, (const unsigned char*)inData, maxLen);
    md5_done(&md, outdata);
    
    unsigned char texturalData[MD5_LEN*2+1];
    for (int i = 0; i<MD5_LEN; ++i) {
        unsigned char c = outdata[i];
        texturalData[i*2] = hex[(c>>4)];
        texturalData[i*2+1] = hex[(c&0x0F)];
    }
    texturalData[MD5_LEN*2] = 0;
    return [NSString stringWithUTF8String:(const char*)texturalData];
}

@end
