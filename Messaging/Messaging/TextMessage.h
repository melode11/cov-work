//
//  TextMessage.h
//  Messaging
//
//  Created by ThemisKing on 7/22/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "Utilities/ChatContentBuilder.h"

@interface TextMessage : Message

@property (nonatomic, retain) ChatContent *content;

@end
