//
//  AppVersionDAO.h
//  AuroraPhone
//
//  Created by Kevin on 3/1/13.
//
//

#import "BaseDAO.h"
#import "PersistImpl.h"

@interface AppVersionDAO : BaseDAO
{
    id<PersistImpl> _impl;
}

@property (nonatomic,retain) NSString *versionNmuber;

- (id)initWithImpl:(id<PersistImpl>) impl;

@end
