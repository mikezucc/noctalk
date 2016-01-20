//
//  ChatViewController.h
//  ;
//
//  Created by Michael Zuccarino on 1/19/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatDelegate <NSObject>

-(void)closeMe:(id)sender;
-(void)minimizeMe:(id)sender;
-(void)receivedNotification:(id)sender notification:(NSDictionary *)notification;

@end

@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id<ChatDelegate> delegate;

@property (strong, nonatomic) UITableView *chatTableView;

@property (strong, nonatomic) UITextField *chatTextfield;
@property (strong, nonatomic) UIButton *sendButton;

@end
