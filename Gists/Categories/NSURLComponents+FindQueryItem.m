//
//  NSURLComponents+FindQueryItem.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "NSURLComponents+FindQueryItem.h"

@implementation NSURLComponents (FindQueryItem)

- (NSString *)queryItemWithName:(NSString *)name
{
    return [[[[self queryItems] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSURLQueryItem *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.name isEqualToString:name];
    }]] firstObject] value];
}

@end
