//
//  ChatTextCell.m
//  NocTalk
//
//  Created by Michael Zuccarino on 1/22/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import "ChatTextCell.h"

@implementation ChatTextCell

- (void)awakeFromNib {
    // Initialization code
    [self.chatImageView.layer setCornerRadius:self.chatImageView.frame.size.height/2];
    [self.chatImageView setClipsToBounds:YES];
    
    UIImageView *profileBackground  = [[UIImageView alloc] initWithFrame:self.chatImageView.frame];
    [profileBackground.layer setCornerRadius:profileBackground.frame.size.height/2];
    [profileBackground.layer setShadowColor:[UIColor colorWithRed:0.5 green:0.6 blue:0.9 alpha:1.0].CGColor];
    [profileBackground.layer setShadowOpacity:0.7];
    [profileBackground.layer setShadowRadius:3.0];
    [profileBackground.layer setShadowPath:[[UIBezierPath bezierPathWithOvalInRect:profileBackground.bounds] CGPath]];
    [profileBackground setTag:10];
    
    [self.contentView insertSubview:profileBackground belowSubview:self.chatImageView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//+(CGSize)approximateCellContentSize:(ChatMessage *)chat
//{
//    
//    
//    return ([textView sizeThatFits:CGSizeMake(self.chatTextView.frame.size.width, 0)].height > 57 ? [textView sizeThatFits:CGSizeMake(self.chatTextView.frame.size.width, 0)] : CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>));
//}

@end
