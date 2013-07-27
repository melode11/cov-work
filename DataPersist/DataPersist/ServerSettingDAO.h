//
//  ServerSettingDAO.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-9-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseDAO.h"
#import "PersistImpl.h"

@class ServerModel;

@interface ServerSettingDAO : BaseDAO
{
    id<PersistImpl> _impl;
}


@property (nonatomic,retain) ServerModel* messagingServerModel;


- (id)initWithImpl:(id<PersistImpl>) impl;

@end
