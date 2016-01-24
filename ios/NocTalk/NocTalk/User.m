//
//  User.m
//  NocTalk
//
//  Created by Michael Zuccarino on 1/22/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import "User.h"

@implementation User

-(id)init {
    self = [super init];
    
    return self;
}

+(User *)withName:(NSString *)username fullname:(NSString *)fullname profileHash:(NSString *)profileHash areacode:(NSString *)areacode
{
    User *aUser = [User new];
    
    aUser.username = username;
    aUser.fullname = fullname;
    aUser.profileHash = profileHash;
    aUser.areacode = areacode;
    
    return aUser;
}

@end
