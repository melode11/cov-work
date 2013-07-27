//
//  SAJSONMissedCallAgent.h
//  AuroraPhone
//
//  Created by ThemisKing on 4/22/13.
//
//

#import "SAJSONHttpAgent.h"
#import "SABizProtocols.h"
#import "HistoryRecord.h"

#define kMISSEDCALL @"calls"

@interface SAJSONMissedCallAgent : SAJSONHttpAgent<SAMissedCallProtocol>
{
@private
    NSArray* _missedCallArray;
}

@end
