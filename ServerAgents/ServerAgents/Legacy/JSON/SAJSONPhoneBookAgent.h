//
//  SAJSONContactsAgent.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONHttpAgent.h"
#import "SABizProtocols.h"

#define kPHONEBOOK @"phonebooks"

@interface SAJSONPhoneBookAgent : SAJSONHttpAgent<SAPhoneBookProtocol>
{
    @private
    NSArray* _contacts;
    NSString* _timestamp;
    BOOL _isUpdated;
}

@end
