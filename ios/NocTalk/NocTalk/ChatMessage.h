//
//  ChatMessage.h
//  NocTalk
//
//  Created by Michael Zuccarino on 1/22/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ChatMessage : NSObject

@property (strong, nonatomic) User *author;
@property (strong, nonatomic) NSString *message;

+(ChatMessage *)withUser:(User *)aUser message:(NSString *)message;

@end
