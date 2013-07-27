//
//  SAJSONProductGroupAgent.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SAJSONHttpAgent.h"
#import "SABizProtocols.h"

@interface SAJSONProductGroupAgent : SAJSONHttpAgent<SAProductGroupProtocol>
{
    NSArray* _groups;
}

@end
