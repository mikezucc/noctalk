//
//  ChatViewController.m
//  NocTalk
//
//  Created by Michael Zuccarino on 1/19/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController () <UITextViewDelegate>

@end

@implementation ChatViewController

-(IBAction)closeMe
{
    __weak id weakSelf = self;
    [self.delegate closeMe:weakSelf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.chatTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"emptyCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    
    return cell;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    self.textViewHeightConstraint.constant = ([textView sizeThatFits:CGSizeMake(self.chatTextView.frame.size.width, 0)].height > 57 ? [textView sizeThatFits:CGSizeMake(self.chatTextView.frame.size.width, 0)].height : 57);
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.chatTextView setNeedsLayout];
        [self.chatTextView layoutIfNeeded];
    }];
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    __weak id weakSelf = self;
    [self.delegate beganEditing:weakSelf];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    __weak id weakSelf = self;
    [self.delegate endedEditing:weakSelf];
}

@end
