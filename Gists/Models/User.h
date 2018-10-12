//
//  User.h
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject <ObjectCreation>

@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) NSURL *avatarURL;

+ (instancetype)anonymousUser;

@end

NS_ASSUME_NONNULL_END
