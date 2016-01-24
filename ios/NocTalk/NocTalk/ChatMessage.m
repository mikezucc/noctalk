//
//  ChatMessage.m
//  NocTalk
//
//  Created by Michael Zuccarino on 1/22/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

+(ChatMessage *)withUser:(User *)aUser message:(NSString *)message
{
    ChatMessage *chat = [ChatMessage new];
    
    chat.author = aUser;
    chat.message = message;
    
    return chat;
}

@end
