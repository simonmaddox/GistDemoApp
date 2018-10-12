//
//  User.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "User.h"

@implementation User

+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary
{
    User *user = [[User alloc] init];
    
    user.login = dictionary[@"login"];
    user.avatarURL = [NSURL URLWithString:@"avatar_url"];
    
    return user;
}

@end
