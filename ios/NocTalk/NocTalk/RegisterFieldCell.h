//
//  RegisterFieldCell.h
//  NocTalk
//
//  Created by Michael Zuccarino on 1/19/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterFieldCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (nonatomic) NSInteger section;
@property (nonatomic) NSInteger row;

@end
