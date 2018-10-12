//
//  ObjectProtocol.h
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ObjectCreation <NSObject>

+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary;

@optional
+ (NSArray *)objectsFromArray:(NSArray *)objects;

@end

NS_ASSUME_NONNULL_END
