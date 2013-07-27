//
//  SAJSONMissedCallAgent.m
//  AuroraPhone
//
//  Created by ThemisKing on 4/22/13.
//
//

#import "SAJSONMissedCallAgent.h"
#import "SAReqParameter.h"
#import "HistoryRecordBuilder.h"

@implementation SAJSONMissedCallAgent

-(void)uploadMissedCall:(NSString*)caller to:(NSString*)receiver accepted:(NSString*)acceptor
{
    NSMutableArray* params = [NSMutableArray arrayWithCapacity:4];
    NSString* calltype;
    if (![[receiver lowercaseString] hasSuffix:@"iphone"]
        && ![[receiver lowercaseString] hasSuffix:@"ipad"]) {
        calltype = [NSString stringWithFormat:@"%d",eCallGroup];
    } else {
        calltype = [NSString stringWithFormat:@"%d",eCallUser];
    }
    
    [params addObject:[SAReqParameter reqParameterWithKey:@"loginname" andValue:caller]];
    [params addObject:[SAReqParameter reqParameterWithKey:@"to" andValue:receiver]];
    [params addObject:[SAReqParameter reqParameterWithKey:@"type" andValue:calltype]];
    [params addObject:[SAReqParameter reqParameterWithKey:@"receiver" andValue:acceptor]];
    [self addCommonParameters:params];
    [self requestWithService:SERVICE_UPLOADMC parameters:params andTimeout:30];
}

-(void)downloadMissedCall:(NSString*)receiver
{
    NSMutableArray* params = [NSMutableArray arrayWithCapacity:1];
    [params addObject:[SAReqParameter reqParameterWithKey:@"loginname" andValue:receiver]];
    [self addCommonParameters:params];
    [self requestWithService:SERVICE_DOWNLOADMC parameters:params andTimeout:30];
}

-(void)confirmMissedCallDownloaded:(NSString*)receiver
{
    NSMutableArray* params = [NSMutableArray arrayWithCapacity:1];
    [params addObject:[SAReqParameter reqParameterWithKey:@"loginname" andValue:receiver]];
    [self addCommonParameters:params];
    [self requestWithService:SERVICE_CONFIRMMC parameters:params andTimeout:30];
}

-(void)clearMissedCallRecord:(NSString*)receiver
{
    NSMutableArray* params = [NSMutableArray arrayWithCapacity:1];
    [params addObject:[SAReqParameter reqParameterWithKey:@"loginname" andValue:receiver]];
    [self addCommonParameters:params];
    [self requestWithService:SERVICE_CLEARMC parameters:params andTimeout:30];
}

-(void)parseBusinessObject:(NSDictionary *)dict code:(NSInteger)bizcode andTimeStamp:(NSString *)timestamp
{
    NSArray* array = [dict objectForKey:kMISSEDCALL];
    NSMutableArray* tmpCallarray = [NSMutableArray arrayWithCapacity:[array count]];
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]init];
    for(NSDictionary* dic in array)
    {
        NSNumber *timeObj = [NSNumber numberWithDouble:[[dic objectForKey:kHistoryRecordTime] longLongValue]/1000.0];
        [mutableDic setDictionary:dic];
        [mutableDic setValue:timeObj forKey:kHistoryRecordTime];
        [tmpCallarray addObject:[HistoryRecordBuilder buildFromDict:mutableDic]];
        
    }
    [mutableDic release];
    _missedCallArray = [[NSArray alloc] initWithArray:tmpCallarray];
}

-(NSArray*)getMissedCallArray {
    return _missedCallArray;
}

-(void)dealloc
{
    [_missedCallArray release];
    [super dealloc];
}
@end
