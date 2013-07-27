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

#define kSASysCode @"syscode"
#define kSABusinessCode @"businesscode"
#define kSATimestamp @"timestamp"
#define kSABusinessObject @"businessobject"

FOUNDATION_EXPORT NSInteger const SACommonBizCode;


@interface SAJSONHttpAgent : SAHttpAgent <SBJsonStreamParserAdapterDelegate>
{
    SASysCode _syscode;
}
-(void) parseBusinessObject:(NSDictionary*) dict code:(NSInteger) bizcode andTimeStamp:(NSString*) timestamp;

-(void)markBusinessError:(NSInteger)bizCode;

@end
