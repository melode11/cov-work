//
//  CurrentMessages.h
//  HelpSource_Application
//
//  Created by ThemisKing on 8/6/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities/ChatContent.h"

@interface CurrentMessages : NSObject

@property (nonatomic, assign) NSInteger peerId;
@property (nonatomic, retain) NSMutableArray* messages;

-(id)initWithPeerId:(NSInteger)userId;
-(void)insertMessage:(ChatContent *)msg;

@end
