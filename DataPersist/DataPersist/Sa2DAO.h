//
//  Sa2DAO.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseDAO.h"
#import "Utilities/Sa2ProfileBuilder.h"
#import "PersistImpl.h"

@interface Sa2DAO : BaseDAO
{
@private
    id<PersistImpl> _impl;
    NSArray* _sa2Profiles;
    BOOL _isDirty;
}
@property (nonatomic,readonly) NSArray *sa2Profiles;

-(id)initWithImpl:(id<PersistImpl>) impl;

-(void)updateSa2Profiles:(NSArray*) sa2Profiles;
@end
