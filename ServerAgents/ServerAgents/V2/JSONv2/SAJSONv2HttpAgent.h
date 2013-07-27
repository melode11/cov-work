//
//  JSONServerAgent.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAHttpAgent.h"
#import "SBJsonStreamParserAdapter.h"

#define kSAResponseCode @"code"
#define kSAResponseStatus @"status"
#define kSAResult @"result"



@interface SAJSONv2HttpAgent : SAHttpAgent <SBJsonStreamParserAdapterDelegate>
{
    SAResponseCode _respCode;
}
-(void) parseBusinessObject:(NSDictionary*) dict;

-(void)markBusinessError:(NSInteger)bizCode;

@end
