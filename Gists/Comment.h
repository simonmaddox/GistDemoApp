//
//  Comment.h
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class User;

@interface Comment : NSObject <ObjectCreation>

@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) User *user;

@end

NS_ASSUME_NONNULL_END
