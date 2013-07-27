//
//  HistoryRecordBuilder.h
//  AuroraPhone
//
//  Created by Yao Melo on 11/13/12.
//
//

#import <Foundation/Foundation.h>
#import "HistoryRecord.h"
@interface HistoryRecordBuilder : NSObject
+(HistoryRecord *)buildFromDict:(NSDictionary *)dic;

+(NSDictionary *)toDictionary:(HistoryRecord *)record;

@end
