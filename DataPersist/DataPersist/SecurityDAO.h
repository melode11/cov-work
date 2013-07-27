//
//  SecurityDAO.h
//  Annotation_iPad
//
//  Created by Yao Melo on 4/17/13.
//
//

#import "BaseDAO.h"
#import "Utilities/DTConstants.h"

@interface SecurityDAO : BaseDAO

@property (nonatomic,retain) NSString *secureToken;
@property (nonatomic,assign) BOOL allowFallback;
@property (nonatomic,assign) SecureType secureType;

@end
