//
//  Github.h
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Gist;

NS_ASSUME_NONNULL_BEGIN

@protocol GithubDelegate <NSObject>
- (UIViewController *)viewControllerForShowingGithubInterfaces;
@end

@interface Github : NSObject

+ (NSString *)gistIDFromURL:(NSURL *)URL;
+ (NSString *)gistIDFromURLString:(NSString *)URLString;

@property (nonatomic, weak) id <GithubDelegate> delegate;

- (void)fetchGistWithURL:(NSURL *)gistURL completion:(void(^)(Gist *gist, NSError *error))completion;
- (void)fetchCommentsforGist:(Gist *)gist completion:(void(^)(NSArray *comments, NSError *error))completion;
- (void)postComment:(NSString *)comment toGist:(Gist *)gist completion:(void(^)(NSError *))completion;

- (BOOL)handleAuthURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
