//
//  HistoryRecord.m
//  AuroraPhone
//
//  Created by Yao Melo on 11/13/12.
//
//

#import "HistoryRecord.h"

@implementation HistoryRecord

@synthesize recordId;
@synthesize type;
@synthesize peerId;
@synthesize peerDisplayName;
@synthesize time;
@synthesize peerDeviceType;
@synthesize callId;

- (id)init
{
    self = [super init];
    if (self) {
        recordId = -1;
    }
    return self;
}

- (void)dealloc
{
    [peerId release];
    [peerDisplayName release];
    [time release];
    [super dealloc];
}

@end
