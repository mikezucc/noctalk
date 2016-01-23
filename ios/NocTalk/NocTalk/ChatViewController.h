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
-(void)beganEditing:(id)sender;
-(void)endedEditing:(id)sender;

@end

@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id<ChatDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *chatTableView;

@property (strong, nonatomic) IBOutlet UITextView *chatTextView;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end
