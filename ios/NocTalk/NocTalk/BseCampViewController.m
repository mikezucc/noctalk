//
//  BseCampViewController.m
//  NocTalk
//
//  Created by Michael Zuccarino on 1/19/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import "BseCampViewController.h"
#import "ChatViewController.h"
#import "ViewController.h"

@interface BseCampViewController () <ChatDelegate>

@property (strong, nonatomic) NSMutableArray *activeChats;

@property (nonatomic) BOOL doOnce;

@property (strong, nonatomic) IBOutlet UIVisualEffectView *visualView;

@end

@implementation BseCampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.activeChats = [NSMutableArray new];
    self.doOnce = NO;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!self.doOnce)
    {
        self.doOnce = YES;
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(IBAction)simulateChat
{
    ChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"chatVC"];
    chatVC
}

-(void)closeMe:(id)sender
{
    
}

-(void)minimizeMe:(id)sender
{
    
}

-(void)receivedNotification:(id)sender notification:(NSDictionary *)notification
{
    
}

@end
