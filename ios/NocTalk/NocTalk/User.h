//
//  User.h
//  NocTalk
//
//  Created by Michael Zuccarino on 1/22/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *fullname;
@property (strong, nonatomic) NSString *profileHash;

// other information and shit here
@property (strong, nonatomic) NSString *areacode;

@end
