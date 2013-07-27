//
//  CrmodCaller.m
//  Annotation_iPad
//
//  Created by WangMinqing on 1/29/13.
//
//

#import "CrmodCaller.h"

@implementation CrmodCaller
@synthesize crmodCallId;
@synthesize cromdCallFlag;
@synthesize crmodCallEndTime;
@synthesize crmodCallName;
@synthesize crmodCallStartTime;
@synthesize CrmodCallType;

-(void)dealloc
{
    [crmodCallEndTime release];
    [crmodCallName release];
    [crmodCallStartTime release];
    [CrmodCallType release];
    [super dealloc];
}


@end
