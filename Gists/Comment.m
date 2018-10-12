//
//  Comment.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "Comment.h"
#import "User.h"

@implementation Comment

+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary
{
    Comment *comment = [[Comment alloc] init];
    
    comment.user = [User objectFromDictionary:dictionary[@"user"]];
    comment.body = dictionary[@"body"];
    
    return comment;
}

+ (NSArray *)objectsFromArray:(NSArray *)objects
{
    NSMutableArray *comments = [NSMutableArray array];
    for (NSDictionary *dictionary in objects){
        Comment *comment = [Comment objectFromDictionary:dictionary];
        if (comment){
            [comments addObject:comment];
        }
    }
    return [NSArray arrayWithArray:comments];
}

@end
