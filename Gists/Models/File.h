//
//  File.h
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface File : NSObject <ObjectCreation>

@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSURL *rawURL;
@property (nonatomic, strong) NSString *content;

@end

NS_ASSUME_NONNULL_END
