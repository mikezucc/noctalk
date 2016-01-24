//
//  ChatViewController.m
//  NocTalk
//
//  Created by Michael Zuccarino on 1/19/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import "ChatViewController.h"
#import "User.h"
#import "ChatMessage.h"
#import "ChatTextCell.h"
#include <stdlib.h>

@interface ChatViewController () <UITextViewDelegate>

@property (strong, nonatomic) NSMutableArray *chatHistory;
@property (strong, nonatomic) NSMutableArray *chatHeights;

@property (strong, nonatomic) UITapGestureRecognizer *titleTapGest;

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
    
    self.chatHistory = [NSMutableArray new];
    self.chatHeights = [NSMutableArray new];
    
    [self.chatTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"emptyCell"];
    [self.chatTableView registerNib:[UINib nibWithNibName:@"ChatTextCell" bundle:nil] forCellReuseIdentifier:@"chatTextCell"];
    
    self.titleTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTitle)];
    [self.titleTapGest setNumberOfTapsRequired:1.0];
    [self.titleTapGest setNumberOfTouchesRequired:1.0];
    [self.titleVisualView addGestureRecognizer:self.titleTapGest];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    ChatTextCell *sampleCell = [[UINib nibWithNibName:@"ChatTextCell" bundle:nil] instantiateWithOwner:nil options:nil][0];
    [sampleCell setFrame:CGRectMake(0, 0, self.chatTableView.frame.size.width, 57)];
    [sampleCell setNeedsLayout];
    [sampleCell layoutIfNeeded];
    
    NSString *sample = @"I once had a dream, that time knows not to cease, and that tides know not hte seas. that students know not C's and that motors know not sieze";
    for (int i=0; i < 10; i++)
    {
        User *user = [User withName:@"damon_devios" fullname:@"James Band" profileHash:@"" areacode:@""];
        ChatMessage *chat = [ChatMessage withUser:user message:[sample substringToIndex:arc4random_uniform(sample.length-1)]];
        sampleCell.chatTextView.text = chat.message;
//        NSLog(@"%f",[sampleCell.chatTextView sizeThatFits:CGSizeMake(self.chatTextView.frame.size.width, 0)].height);
        [self.chatHeights addObject:@(([sampleCell.chatTextView sizeThatFits:CGSizeMake(self.chatTextView.frame.size.width, 0)].height + 25 > 70 ? [sampleCell.chatTextView sizeThatFits:CGSizeMake(self.chatTextView.frame.size.width, 0)].height + 25 : 70))];
        [self.chatHistory addObject:chat];
    }
    
//    NSLog(@"chat size array is %@",self.chatHeights);
    
    [self.chatTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((NSNumber *)[self.chatHeights objectAtIndex:indexPath.row]).floatValue;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.chatHistory.count ? 1 : 0);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatHistory.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.chatHistory objectAtIndex:indexPath.row] isKindOfClass:[ChatMessage class]])
    {
        ChatTextCell *cell = (ChatTextCell *)[tableView dequeueReusableCellWithIdentifier:@"chatTextCell" forIndexPath:indexPath];
        
        cell.chatTextView.text = ((ChatMessage *)[self.chatHistory objectAtIndex:indexPath.row]).message;
        
        [cell.contentView setNeedsLayout];
        [cell.contentView layoutIfNeeded];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - chat text view dellllllies

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    self.textViewHeightConstraint.constant = ([textView sizeThatFits:CGSizeMake(self.chatTextView.frame.size.width, 0)].height + 8 > 57+8 ? [textView sizeThatFits:CGSizeMake(self.chatTextView.frame.size.width, 0)].height+8 : 57+8);
    
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
    
    [textView.layer setBorderWidth:0.5];
    [textView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [textView.layer setCornerRadius:10.0];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    __weak id weakSelf = self;
    [self.delegate endedEditing:weakSelf];
    
    [textView.layer setBorderWidth:0];
    [textView.layer setBorderColor:[UIColor clearColor].CGColor];
}

#pragma mark - responsies

-(void)tappedTitle {
    NSLog(@"%s",__FUNCTION__);
    __weak id weakSelf = self;
    [self.delegate tappedTitleView:weakSelf];
}

@end
