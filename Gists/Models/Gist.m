//
//  Gist.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "Gist.h"
#import "File.h"
#import "User.h"

@implementation Gist

+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary
{
    Gist *gist = [[Gist alloc] init];
    
    gist.identifier = dictionary[@"id"];
    
    gist.URL = [NSURL URLWithString:dictionary[@"url"]];
    gist.HTMLURL = [NSURL URLWithString:dictionary[@"html_url"]];
    gist.commentsURL = [NSURL URLWithString:dictionary[@"comments_url"]];
    
    gist.files = [File objectsFromArray:[dictionary[@"files"] allValues]];
    gist.owner = [User objectFromDictionary:dictionary[@"owner"]];
        
    return gist;
}

- (NSString *)description
{
    return [[[super description] stringByAppendingString:@" - "] stringByAppendingString:self.identifier];
}

@end
