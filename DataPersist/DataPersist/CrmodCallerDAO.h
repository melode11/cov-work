//
//  CrmodCallerDAO.h
//  Annotation_iPad
//
//  Created by WangMinqing on 1/29/13.
//
//

#import "BaseDAO.h"
#import "Utilities/CrmodCaller.h"
#import "PersistImpl.h"

@interface CrmodCallerDAO : BaseDAO{

       @private
       id<PersistImpl> _impl;
       BOOL _isLoad;
       BOOL _isCrmodUpdate;
       NSMutableArray* _crmodCallerLists;

}

-(id)initWithImpl:(id<PersistImpl>) persistImpl;
-(NSMutableArray*) getCrmodCallerLists;
-(void) convertCRMODCallerArray:(NSArray*)crmodCallers intoDictArray:(NSMutableArray*) dicArray;
-(void)updateCrmodRecord:(CrmodCaller*)crmodCaller;
-(void)removeCrmodRecord:(CrmodCaller*)crmodCaller;
@end
