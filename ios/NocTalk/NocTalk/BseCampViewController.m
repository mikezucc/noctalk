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

@property (strong, nonatomic) IBOutlet UIToolbar *bottomBar;

@end

@implementation BseCampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.activeChats = [NSMutableArray new];
    self.doOnce = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowHandler:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
}

-(void)keyboardWillShowHandler:(NSNotification *)notification {
    
    ChatViewController *chatVC = [self.activeChats lastObject];
    
    CGRect origF = chatVC.view.superview.frame;
    
    CGFloat bufferSpace = 15.0f;
    origF.origin.x = 0;
    origF.origin.y = + [[UIApplication sharedApplication] statusBarFrame].size.height;
    origF.size.height = [[UIScreen mainScreen] bounds].size.height - (origF.origin.y + 255 + self.bottomBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height);
    origF.size.width = [[UIScreen mainScreen] bounds].size.width;
    
    [chatVC.view.superview setFrame:origF];
    [chatVC.view setNeedsLayout];
    [chatVC.view layoutIfNeeded];
}

- (void) keyboardWillHideHandler:(NSNotification *)notification {
    ChatViewController *chatVC = [self.activeChats lastObject];
    
    CGRect origF = chatVC.view.superview.frame;
    
    CGFloat bufferSpace = 15.0f;
    origF.origin.x = bufferSpace;
    origF.origin.y = bufferSpace/2 + [[UIApplication sharedApplication] statusBarFrame].size.height;
    origF.size.height = [[UIScreen mainScreen] bounds].size.height - (origF.origin.y + 2*bufferSpace + self.bottomBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height);
    origF.size.width = [[UIScreen mainScreen] bounds].size.width - bufferSpace*2;
    
    [chatVC.view.superview setFrame:origF];
    [chatVC.view setNeedsLayout];
    [chatVC.view layoutIfNeeded];
    
}
-(void)viewDidAppear:(BOOL)animated
{
//    if (!self.doOnce)
//    {
//        self.doOnce = YES;
//        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
//        [self presentViewController:vc animated:YES completion:nil];
//    }
}

-(IBAction)simulateChat
{
    CGRect frmb = [[UIScreen mainScreen] bounds];
    CGFloat bufferSpace = 15.0f;
    frmb.origin.x = bufferSpace;
    frmb.origin.y = bufferSpace/2 + [[UIApplication sharedApplication] statusBarFrame].size.height;
    frmb.size.height = [[UIScreen mainScreen] bounds].size.height - (frmb.origin.y + 2*bufferSpace + self.bottomBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height);
    frmb.size.width = [[UIScreen mainScreen] bounds].size.width - bufferSpace*2;

    
    UIView *container = [[UIView alloc] initWithFrame:frmb];
    container.alpha = 0;
    ChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"chatVC"];
    chatVC.view.frame = container.bounds;
    [chatVC.view.layer setMasksToBounds:YES];
    [container addSubview:chatVC.view];
    [self addChildViewController:chatVC];
    [chatVC didMoveToParentViewController:self];
    chatVC.delegate = self;
    [container.layer setCornerRadius:10.0];
    [container setClipsToBounds:YES];
    [self.view addSubview:container];
    
    [self.activeChats addObject:chatVC];
    
    container.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        container.alpha = 1.0;
        container.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        //
    }];
}

#pragma mark - Chat dellies

-(void)closeMe:(id)sender
{
    
}

-(void)minimizeMe:(id)sender
{
    
}

-(void)receivedNotification:(id)sender notification:(NSDictionary *)notification
{
    
}

-(void)beganEditing:(id)sender
{
    [self keyboardWillShowHandler:nil];
}

-(void)endedEditing:(id)sender
{
    [self keyboardWillHideHandler:nil];
}

@end
