//
//  File.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "File.h"

@implementation File

+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary
{
    File *file = [[File alloc] init];

    file.filename = dictionary[@"filename"];
    file.type = dictionary[@"type"];
    file.language = dictionary[@"language"];
    file.rawURL = [NSURL URLWithString:dictionary[@"raw_url"]];
    file.content = dictionary[@"content"];

    return file;
}

+ (NSArray *)objectsFromArray:(NSArray *)objects
{
    NSMutableArray *files = [NSMutableArray array];
    for (NSDictionary *dictionary in objects){
        File *file = [File objectFromDictionary:dictionary];
        if (file){
            [files addObject:file];
        }
    }
    return [NSArray arrayWithArray:files];
}

- (NSString *)description
{
    return [[[super description] stringByAppendingString:@" - "] stringByAppendingString:self.filename];
}

@end
