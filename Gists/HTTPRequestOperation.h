//
//  HTTPRequestOperation.h
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequestOperation : NSOperation

@property (nonatomic, strong) NSURLRequest *request;

@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSError *responseError;

- (instancetype)initWithRequest:(NSURLRequest *)request;

@end
