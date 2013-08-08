//
//  ChatContent.h
//  Utilities
//
//  Created by Yao Melo on 7/30/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _ChatType {
    eChatOutgoing = 1,
    eChatIncoming = 2
} ChatType;

@interface ChatContent : NSObject

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *peerId;
@property (nonatomic) ChatType type;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) NSTimeInterval timestamp;

@end
