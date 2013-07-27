//
//  PersistImpl.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PersistImpl<NSObject>

@optional
-(void)persistAllWithDictionary:(NSDictionary*) dict toKey:(NSString*) key;

-(void)persistAllWithArray:(NSArray*) array toKey:(NSString*) key;

-(NSArray*) loadAsArrayFromKey:(NSString*) key;

-(NSDictionary*) loadAsDictionaryFromKey:(NSString*) key;

-(void) cleanForKey:(NSString*)key;

@end
