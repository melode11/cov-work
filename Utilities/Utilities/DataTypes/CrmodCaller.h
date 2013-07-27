//
//  CrmodCaller.h
//  Annotation_iPad
//
//  Created by WangMinqing on 1/29/13.
//
//

#import <Foundation/Foundation.h>

@interface CrmodCaller : NSObject

@property (nonatomic,assign) NSInteger crmodCallId;
@property(nonatomic,assign) BOOL cromdCallFlag;
@property(nonatomic,retain) NSString *crmodCallEndTime;
@property(nonatomic,retain) NSString *crmodCallStartTime;
@property(nonatomic,retain) NSString *crmodCallName;
@property(nonatomic,retain) NSString *CrmodCallType;
@end
