//
//  ParamsMessage.h
//  Messaging
//
//  Created by Yao Melo on 7/30/13.
//  Copyright (c) 2013 Shanghai. All rights reserved.
//

#import "Message.h"

@interface ParamsMessage : Message
{
    NSMutableDictionary* _params;
    NSString* _type;
}

-(id)initWithParams:(NSMutableDictionary*)dic andType:(NSString*)type;

@end
