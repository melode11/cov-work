//
//  HistoryRecordBuilder.m
//  AuroraPhone
//
//  Created by Yao Melo on 11/13/12.
//
//

#import "HistoryRecordBuilder.h"
#import "DTConstants.h"
#import "NSDictionary+SafeAccess.h"
#import "NSString+Name_Device.h"
#import "Contact.h"

@implementation HistoryRecordBuilder

+(HistoryRecord *)buildFromDict:(NSDictionary *)dic
{
    @try {
        HistoryRecord *record = [[[HistoryRecord alloc] init]autorelease];
        record.recordId =[[dic objectForKeyNullToNil:kHistoryRecordId] intValue];
        NSNumber *typeNum = [dic objectForKeyNullToNil:kHistoryRecordType];
        if(!typeNum)
        {
            record.type = eHistoryRecordIncomingMiss;
        }
        else
        {
            record.type = [typeNum intValue];
        }
        record.peerId = [[dic objectForKeyFailedOnNull:kHistoryRecordPeerId] description];
        record.peerDisplayName = [[dic objectForKeyNullToNil:kHistoryRecordPeerDisplayName] description];
                
        record.peerDeviceType =  [[dic objectForKeyNullToNil:kHistoryRecordPeerDeviceType] description];
        if(!record.peerDeviceType)
        {
            record.peerDeviceType = [record.peerId device];
        }
        
        record.time =[NSDate dateWithTimeIntervalSince1970:[[dic objectForKeyFailedOnNull:kHistoryRecordTime] doubleValue]];
        record.callId = [[dic objectForKeyFailedOnNull:kHistoryRecordCallId] intValue];
        return record;
    }
    @catch (NSException *exception) {
        DDLogError(@"Failed to create history record,with exception:%@",[exception reason]);
        return nil;
    }
    
}


+(NSDictionary *)toDictionary:(HistoryRecord *)record
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:record.recordId],kHistoryRecordId,
            [NSNumber numberWithInt:record.type],kHistoryRecordType,record.peerId,kHistoryRecordPeerId,record.peerDisplayName,kHistoryRecordPeerDisplayName, record.peerDeviceType,kHistoryRecordPeerDeviceType,[NSNumber numberWithDouble:[record.time timeIntervalSince1970]],kHistoryRecordTime, [NSNumber numberWithInt:record.callId],kHistoryRecordCallId, nil];
}

@end
