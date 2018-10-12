//
//  Github.h
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Gist;

NS_ASSUME_NONNULL_BEGIN

@interface Github : NSObject

+ (NSString *)gistIDFromURL:(NSURL *)URL;
+ (NSString *)gistIDFromURLString:(NSString *)URLString;

- (void)fetchGistWithURL:(NSURL *)gistURL completion:(void(^)(Gist *gist, NSError *error))completion;
- (void)fetchCommentsforGist:(Gist *)gist completion:(void(^)(NSArray *comments, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
