//
//  NSDictionary+SafeAccess.h
//  AuroraPhone
//
//  Created by Yao Melo on 3/7/13.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeAccess)

-(id)nulltoNilObjectForKey:(id)key;

-(id)objectForKeyFailedOnNull:(id)key;

-(id)objectForKeyNullToNil:(id)key;
@end
