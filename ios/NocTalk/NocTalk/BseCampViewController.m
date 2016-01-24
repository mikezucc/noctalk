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
#import "WhoisViewController.h"

@interface BseCampViewController () <ChatDelegate, WhoisDelegate>

@property (strong, nonatomic) NSMutableArray *activeChats;
@property (nonatomic) BOOL doOnce;
@property (nonatomic) BOOL covered;
@property (nonatomic) BOOL showho;

@property (strong, nonatomic) IBOutlet UIVisualEffectView *visualView;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) dispatch_queue_t animCompleteQueue;
@property (nonatomic) dispatch_semaphore_t animCompleteSema;

@property (strong, nonatomic) WhoisViewController *whoisVC;

@end

@implementation BseCampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.activeChats = [NSMutableArray new];
    self.doOnce = NO;
    self.covered = NO;
    self.showho = NO;
    
    self.animCompleteQueue = dispatch_queue_create("animCompleteQueue", DISPATCH_QUEUE_SERIAL);
    self.animCompleteSema = dispatch_semaphore_create(0);
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHideHandler:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShowHandler:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    if (!self.doOnce)
    {
        self.doOnce = YES;
        //        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
        //        [self presentViewController:vc animated:YES completion:nil];
        
        [self.scrollView setScrollEnabled:NO];
        [self.scrollView setContentInset:UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0)];
        [self createEverybodyChat];
        [self createEverybodyChat];
        [self createEverybodyChat];
    }
}

#pragma mark - naughties

-(void)keyboardWillShowHandler:(NSNotification *)notification {
    
    ChatViewController *chatVC = [self.activeChats lastObject];
    
    CGRect origF = chatVC.view.superview.frame;
    
    CGFloat bufferSpace = 15.0f;
    origF.origin.x = 0;
    origF.origin.y = [[UIApplication sharedApplication] statusBarFrame].size.height;
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

-(IBAction)simulateChat {
    if (self.covered) {
        self.covered = NO;
        [self magnifyToChat:nil];
    } else {
        self.covered = YES;
        [self expandToSlash:nil];
    }
}

#pragma mark - convenience
-(void)createEverybodyChat{
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
    [self.scrollView addSubview:container];
    
    chatVC.targetString = @"everybody";
    
    [self.activeChats addObject:chatVC];
    
    container.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        container.alpha = 1.0;
        container.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        //
    }];
}

-(IBAction)showWhois {
    if (self.whoisVC) {
        if (self.showho) {
            self.showho = NO;
            [self hideWhoIs];
        } else {
            self.showho = YES;
            [self.view insertSubview:self.visualView belowSubview:self.bottomBar];
            [self.view insertSubview:self.whoisVC.view.superview belowSubview:self.bottomBar];
            
            CGRect frmb = [[UIScreen mainScreen] bounds];
            CGFloat bufferSpace = 15.0f;
            frmb.origin.x = bufferSpace;
            frmb.origin.y = bufferSpace/2 + [[UIApplication sharedApplication] statusBarFrame].size.height;
            frmb.size.height = [[UIScreen mainScreen] bounds].size.height - (frmb.origin.y + 2*bufferSpace + self.bottomBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height);
            frmb.size.width = [[UIScreen mainScreen] bounds].size.width - bufferSpace*2;
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.whoisVC.view.superview.frame = frmb;
            } completion:^(BOOL finished) {
                //
            }];
        }
    } else {
        self.showho = YES;
        CGRect frmb = [[UIScreen mainScreen] bounds];
        CGFloat bufferSpace = 15.0f;
        frmb.origin.x = bufferSpace;
        frmb.origin.y = bufferSpace/2 + [[UIApplication sharedApplication] statusBarFrame].size.height;
        frmb.size.height = [[UIScreen mainScreen] bounds].size.height - (frmb.origin.y + 2*bufferSpace + self.bottomBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height);
        frmb.size.width = [[UIScreen mainScreen] bounds].size.width - bufferSpace*2;
        
        
        UIView *container = [[UIView alloc] initWithFrame:frmb];
        container.alpha = 0;
        WhoisViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"whois"];
        chatVC.view.frame = container.bounds;
        [chatVC.view.layer setMasksToBounds:YES];
        [container addSubview:chatVC.view];
        [self addChildViewController:chatVC];
        [chatVC didMoveToParentViewController:self];
        chatVC.delegate = self;
        [container.layer setCornerRadius:10.0];
        [container setClipsToBounds:YES];
        
        [self.view insertSubview:self.visualView belowSubview:self.bottomBar];
        [self.view insertSubview:container belowSubview:self.bottomBar];
        
        self.whoisVC = chatVC;
        
        container.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            container.alpha = 1.0;
            container.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            //
        }];
    }
}

-(void)hideWhoIs {
    [self.view sendSubviewToBack:self.visualView];
    
    CGRect frm = self.whoisVC.view.superview.frame;
    frm.origin.y = self.bottomBar.frame.origin.y;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.whoisVC.view.superview.frame = frm;
    } completion:^(BOOL finished) {
        //
    }];
}

#pragma mark - visual viagara

-(void)expandToSlash:(id)chatToFocus {
    ChatViewController *chatCast = (ChatViewController *)chatToFocus;
    if (chatToFocus) {
        NSLog(@"%s DEBUG 5",__FUNCTION__);
        NSInteger count = [self.activeChats count];
        CGFloat divHeight = 58;
        if (count <= 6) {
            divHeight = self.scrollView.frame.size.height/count;
        }
        NSInteger lastP = 0;
        for (ChatViewController *chat in self.activeChats) {
            CGRect newF = chat.view.superview.frame;
            newF.origin.y = lastP;
            newF.size.height = divHeight;
            chat.view.superview.frame = newF;
            
            lastP = chat.view.superview.frame.origin.y + chat.view.superview.frame.size.height + 15;
            
            chat.chatTitleViewHeightConstraint.constant = chat.view.frame.size.height;
            
            [chat.view setNeedsLayout];
            [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [chat.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                //
                dispatch_semaphore_signal(self.animCompleteSema);
            }];
        }
        [self.scrollView setContentSize:CGSizeMake(0, lastP + 8)];
        [self.scrollView setScrollEnabled:YES];
        __weak BseCampViewController *weakSelf = self;
        dispatch_async(self.animCompleteQueue, ^{
            for (int i=0; i < weakSelf.activeChats.count; i++) {
                dispatch_semaphore_wait(weakSelf.animCompleteSema,dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC));
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.scrollView setContentOffset:CGPointMake(0,  chatCast.view.superview.frame.origin.y - [UIApplication sharedApplication].statusBarFrame.size.height) animated:YES] ;
            });
        });
    } else {
        NSLog(@"%s DEBUG 7",__FUNCTION__);
        NSInteger count = [self.activeChats count];
        CGFloat divHeight = 58;
        if (count <= 6) {
            divHeight = self.scrollView.frame.size.height/count;
        }
        NSInteger lastP = 0;
        for (ChatViewController *chat in self.activeChats) {
            CGRect newF = chat.view.superview.frame;
            newF.origin.y = lastP;
            newF.size.height = divHeight;
            chat.view.superview.frame = newF;
            
            lastP = chat.view.superview.frame.origin.y + chat.view.superview.frame.size.height + 15;
            
            chat.chatTitleViewHeightConstraint.constant = chat.view.frame.size.height;
            
            [chat.view setNeedsLayout];
            [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [chat.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                //
                dispatch_semaphore_signal(self.animCompleteSema);
            }];
        }
        __weak BseCampViewController *weakSelf = self;
        dispatch_async(self.animCompleteQueue, ^{
            for (int i=0; i < weakSelf.activeChats.count; i++) {
                dispatch_semaphore_wait(weakSelf.animCompleteSema,dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC));
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.scrollView setContentSize:CGSizeMake(0, lastP + 8)];
                [weakSelf.scrollView setScrollEnabled:YES];
            });
        });
    }
}

-(void)magnifyToChat:(id)chatToFocus {
    ChatViewController *chatCast = (ChatViewController *)chatToFocus;
    if (chatToFocus) {
        NSLog(@"%s DEBUG 3",__FUNCTION__);
        NSInteger count = [self.activeChats count];
        CGFloat divHeight = [[UIScreen mainScreen] bounds].size.height - self.bottomBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
        NSInteger lastP = 0;
        for (ChatViewController *chat in self.activeChats) {
            CGRect newF = chat.view.superview.frame;
            newF.origin.y = lastP + [UIApplication sharedApplication].statusBarFrame.size.height;
            newF.size.height = divHeight;
            chat.view.superview.frame = newF;
            
            lastP = chat.view.superview.frame.origin.y + chat.view.superview.frame.size.height + 15;
            
            chat.chatTitleViewHeightConstraint.constant = 43;
            
            [chat.view setNeedsLayout];
            [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [chat.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                //
                dispatch_semaphore_signal(self.animCompleteSema);
            }];
        }
        [self.scrollView setContentSize:CGSizeMake(0, lastP + 8)];
        [self.scrollView setScrollEnabled:YES];
        __weak BseCampViewController *weakSelf = self;
        dispatch_async(self.animCompleteQueue, ^{
            for (int i=0; i < weakSelf.activeChats.count; i++) {
                dispatch_semaphore_wait(weakSelf.animCompleteSema,dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC));
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.scrollView setContentOffset:CGPointMake(0,  chatCast.view.superview.frame.origin.y - [UIApplication sharedApplication].statusBarFrame.size.height) animated:YES];
            });
        });
    } else {
        NSLog(@"%s DEBUG 4",__FUNCTION__);
        NSInteger count = [self.activeChats count];
        CGFloat divHeight = [[UIScreen mainScreen] bounds].size.height - self.bottomBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
        NSInteger originalHeight = self.scrollView.contentSize.height;
        NSInteger lastP = 0;
        for (ChatViewController *chat in self.activeChats) {
            CGRect newF = chat.view.superview.frame;
            newF.origin.y = lastP  + [UIApplication sharedApplication].statusBarFrame.size.height;
            newF.size.height = divHeight;
            chat.view.superview.frame = newF;
            
            lastP = chat.view.superview.frame.origin.y + chat.view.superview.frame.size.height + 15;
            
            chat.chatTitleViewHeightConstraint.constant = 43;
            
            [chat.view setNeedsLayout];
            [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [chat.view layoutIfNeeded];
                //                if (chat == [self.activeChats lastObject])
                //                {
                
                //                }
            } completion:^(BOOL finished) {
                //
            }];
        }
        [self.scrollView setContentSize:CGSizeMake(0, lastP + 8)];
        [self.scrollView setScrollEnabled:YES];
    }
}

#pragma mark - Chat dellies

-(void)tappedTitleView:(id)sender {
    if (self.covered) {
        self.covered = NO;
        NSLog(@"%s DEBUG 2",__FUNCTION__);
        [self magnifyToChat:sender];
    } else {
        self.covered = YES;
        NSLog(@"%s DEBUG 1",__FUNCTION__);
        [self expandToSlash:sender];
    }
}

-(void)closeMe:(id)sender {
    
}

-(void)minimizeMe:(id)sender {
    
}

-(void)receivedNotification:(id)sender notification:(NSDictionary *)notification {
    
}

-(void)beganEditing:(id)sender {
    [self.scrollView setScrollEnabled:NO];
    
    ChatViewController *chatVC = (ChatViewController *)sender;
    
    NSInteger count = [self.activeChats count];
    CGFloat divHeight = [[UIScreen mainScreen] bounds].size.height - self.bottomBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    NSInteger lastP = 0;
    for (ChatViewController *chat in self.activeChats) {
        CGRect newF = chat.view.superview.frame;
        newF.origin.y = lastP + [UIApplication sharedApplication].statusBarFrame.size.height;
        newF.size.height = divHeight;
        chat.view.superview.frame = newF;
        
        lastP = chat.view.superview.frame.origin.y + chat.view.superview.frame.size.height + 15;
        
        chat.chatTitleViewHeightConstraint.constant = 43;
        
        [chat.view setNeedsLayout];
        [chat.view layoutIfNeeded];
    }
    [self.scrollView setContentSize:CGSizeMake(0, lastP + 8)];
    [self.scrollView setScrollEnabled:YES];
    __weak BseCampViewController *weakSelf = self;
    [weakSelf.scrollView setContentOffset:CGPointMake(0,  chatVC.view.superview.frame.origin.y - [UIApplication sharedApplication].statusBarFrame.size.height) animated:NO];
    
    CGRect origF = chatVC.view.superview.frame;
    
    CGFloat bufferSpace = 15.0f;
    origF.origin.x = 0;
    origF.origin.y = self.scrollView.contentOffset.y;
    NSLog(@"%s %f",__FUNCTION__, origF.origin.y);
//    [self.scrollView setContentOffset:CGPointMake(0, origF.origin.y) animated:YES];
    origF.size.height = [[UIScreen mainScreen] bounds].size.height - ( 255 + self.bottomBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height);
    origF.size.width = [[UIScreen mainScreen] bounds].size.width;
    
    [chatVC.view.superview setFrame:origF];
    [chatVC.view setNeedsLayout];
    [chatVC.view layoutIfNeeded];
}

-(void)endedEditing:(id)sender {
    [self.scrollView setScrollEnabled:YES];
    
    ChatViewController *chatVC = (ChatViewController *)sender;
    
    [self magnifyToChat:chatVC];
    
    CGRect origF = chatVC.view.superview.frame;
    
    CGFloat bufferSpace = 15.0f;
    origF.origin.x = bufferSpace;
    origF.origin.y = self.scrollView.contentOffset.y;
    NSLog(@"%s %f",__FUNCTION__, origF.origin.y);
//    [self.scrollView setContentOffset:CGPointMake(0, origF.origin.y) animated:YES];
    origF.size.height = [[UIScreen mainScreen] bounds].size.height - ( 2*bufferSpace + self.bottomBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height);
    origF.size.width = [[UIScreen mainScreen] bounds].size.width - bufferSpace*2;
    
    [chatVC.view.superview setFrame:origF];
    [chatVC.view setNeedsLayout];
    [chatVC.view layoutIfNeeded];
}

@end
