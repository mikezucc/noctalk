//
//  ChatTextCell.h
//  NocTalk
//
//  Created by Michael Zuccarino on 1/22/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"

@interface ChatTextCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *chatImageView;
@property (strong, nonatomic) IBOutlet UITextView *chatTextView;

+(CGSize)approximateCellContentSize:(ChatMessage *)chat;

@end
