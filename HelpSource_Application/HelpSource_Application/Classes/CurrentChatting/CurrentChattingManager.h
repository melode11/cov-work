//
//  CurrentChattingManager.h
//  HelpSource_Application
//
//  Created by ThemisKing on 8/6/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities/ChatContent.h"

@interface CurrentChattingManager : NSObject

@property (nonatomic, assign) NSInteger currentUser;
@property (nonatomic, retain) NSMutableArray *chattingRecords;

+(CurrentChattingManager*) sharedInstance;

-(NSMutableArray*)getMessagesWith:(NSInteger)peerId;
-(void)addMessage:(ChatContent*)msg with:(NSInteger)peerId;

@end
