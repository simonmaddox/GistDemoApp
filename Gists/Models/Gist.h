//
//  Gist.h
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class File;
@class User;
@class Comment;

@interface Gist : NSObject <ObjectCreation>

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, copy) NSURL *HTMLURL;
@property (nonatomic, copy) NSURL *commentsURL;

@property (nonatomic, strong) NSArray <File *> *files;
@property (nonatomic, strong) User * owner;
@property (nonatomic, strong) NSArray <Comment *> *comments;

@end

NS_ASSUME_NONNULL_END
