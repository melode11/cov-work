//
//  CrmodCallerBuilder.m
//  Annotation_iPad
//
//  Created by WangMinqing on 1/29/13.
//
//

#import "CrmodCallerBuilder.h"
#import "DTConstants.h"

@implementation CrmodCallerBuilder


+(CrmodCaller*) buildFromDict:(NSDictionary*) dict;
{
    CrmodCaller *crmodCaller = [[[CrmodCaller alloc]init]autorelease];
    crmodCaller.cromdCallFlag = [[dict objectForKey:kCrmodCallerFlag]boolValue];
    crmodCaller.crmodCallStartTime = [dict objectForKey:kCrmodCallerStartTime];
    crmodCaller.crmodCallName = [dict valueForKey:kCrmodCallerName];
    crmodCaller.crmodCallEndTime = [dict objectForKey:kCrmodCallerEndTime];
    crmodCaller.CrmodCallType = [dict objectForKey:kCrmodCallerType];
    return crmodCaller;
}

+(NSDictionary*)toDictionary:(CrmodCaller*) crmodCaller;

{
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",crmodCaller.cromdCallFlag],kCrmodCallerFlag,crmodCaller.crmodCallEndTime,kCrmodCallerEndTime,crmodCaller.crmodCallName,kCrmodCallerName,crmodCaller.crmodCallStartTime,kCrmodCallerStartTime,crmodCaller.CrmodCallType,kCrmodCallerType,nil];
}


@end
