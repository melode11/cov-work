//
//  CrmodCallerDAO.m
//  Annotation_iPad
//
//  Created by WangMinqing on 1/29/13.
//
//

#import "CrmodCallerDAO.h"
#import "Utilities/CrmodCallerBuilder.h"

#define CRMOD_FILE @"CRMOD_log"

@implementation CrmodCallerDAO

-(id)initWithImpl:(id<PersistImpl>) persistImpl
{
    self = [super init];
    if(self){
        _impl = [persistImpl retain];
        _isLoad = NO;
        _crmodCallerLists = [[NSMutableArray alloc] init];
        [self load];
    }
    return self;
}

-(void)load{

    if(_isLoad)
    {
        return;
    }
    NSArray* tempCrmodCallerLists = [_impl loadAsArrayFromKey:CRMOD_FILE];
    for(NSMutableDictionary* dic in tempCrmodCallerLists)
    {
        [_crmodCallerLists addObject:[CrmodCallerBuilder buildFromDict:dic]];
    }
   
    _isCrmodUpdate = NO;
    _isLoad = YES;
}


-(void)store
{
    if(_isCrmodUpdate)
    {
        NSMutableArray* dicArr = [[NSMutableArray alloc]initWithCapacity:[_crmodCallerLists count]];
        [self convertCRMODCallerArray:_crmodCallerLists intoDictArray:dicArr];
        [_impl persistAllWithArray:dicArr toKey:CRMOD_FILE];
        [dicArr release];
        _isCrmodUpdate = NO;
    }
}

-(void) convertCRMODCallerArray:(NSArray*)crmodCallers intoDictArray:(NSMutableArray*) dicArray;
{
    for(CrmodCaller* crmodCaller in crmodCallers)
    {
        [dicArray addObject:[CrmodCallerBuilder toDictionary:crmodCaller]];
    }
}

-(NSMutableArray*) getCrmodCallerLists{
    return _crmodCallerLists;
}

-(void)updateCrmodRecord:(CrmodCaller*)crmodCaller{
   
    [_crmodCallerLists addObject:crmodCaller];
    _isCrmodUpdate = YES;
}

-(void)removeCrmodRecord:(CrmodCaller*)crmodCaller{

    for(NSInteger i = [_crmodCallerLists count] -1;i>=0;i--)
    {
        CrmodCaller *tempCrmodRecord = [_crmodCallerLists objectAtIndex:i];
        if([tempCrmodRecord.crmodCallStartTime isEqualToString: crmodCaller.crmodCallStartTime])
        {
            [_crmodCallerLists removeObjectAtIndex:i];
            _isCrmodUpdate = YES;
            break;
        }
    }
}

-(void)clean
{
    [_crmodCallerLists removeAllObjects];
    _isLoad = NO;
    [_impl cleanForKey:CRMOD_FILE];
}

-(void)dealloc
{
    [_impl release];
    [_crmodCallerLists release];
    _crmodCallerLists = nil;
    [super dealloc];
}

@end
