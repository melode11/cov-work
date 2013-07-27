//
//  HistoryRecord.h
//  AuroraPhone
//
//  Created by Yao Melo on 11/13/12.
//
//

#import <Foundation/Foundation.h>

const int history_type_mask_miss = 0x4;

typedef enum _MissedCallType
{
    eCallUser = 1,
    eCallGroup
} MissedCallType;

typedef enum _HistoryRecordType
{
    eHistoryRecordIncoming = 1,
    eHistoryRecordOutgoing = 2,
    //use 4 as miss mask
    eHistoryRecordIncomingMiss = 0x4|eHistoryRecordIncoming,
    eHistoryRecordOutgoingMiss = 0x4|eHistoryRecordOutgoing
} HistoryRecordType;

@interface HistoryRecord : NSObject

//id property for db use only,meanless.
@property(nonatomic,assign) NSInteger recordId;
@property(nonatomic,assign) HistoryRecordType type;
@property(nonatomic,retain) NSString *peerId;
@property(nonatomic,retain) NSString *peerDisplayName;
@property(nonatomic,retain) NSString *peerDeviceType;
@property(nonatomic,retain) NSDate *time;
@property(nonatomic,assign) NSInteger callId;

@end
