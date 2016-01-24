//
//  WhoisViewController.h
//  NocTalk
//
//  Created by Michael Zuccarino on 1/23/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol WhoisDelegate <NSObject>

-(void)hideWhoIs;
-(void)talkToUser:(User *)aUser;

@end

@interface WhoisViewController : UIViewController


// delis
@property (weak, nonatomic) id<WhoisDelegate> delegate;

// UI
@property (strong, nonatomic) IBOutlet UITableView *whoisTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatTitleViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *titleVisualView;

@end
