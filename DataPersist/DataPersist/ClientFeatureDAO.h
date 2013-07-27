//
//  ClientFeatureDAO.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDAO.h"
#import "PersistImpl.h"
#import "Utilities/ClientFeature.h"
@interface ClientFeatureDAO : BaseDAO
{
    @private
    id<PersistImpl> _impl;
    NSArray* _features;
}

-(id)initWithImpl:(id<PersistImpl>)impl;

-(ClientFeature*) featureForCode:(NSString*) code;

-(void) updateFeatures:(NSArray*) features;

-(NSArray *)AllFeatures;
@end
