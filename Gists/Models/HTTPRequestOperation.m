//
//  HTTPRequestOperation.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "HTTPRequestOperation.h"

@interface HTTPRequestOperation (){
    BOOL _executing;
    BOOL _finished;
    BOOL _cancelled;
}



@property (nonatomic, strong) NSURLSessionDataTask *task;
@end


@implementation HTTPRequestOperation

+ (NSURLSession *)session
{
    return [NSURLSession sharedSession];
}

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    if (self = [self init]){
        _request = request;
    }
    return self;
}

- (void)start
{
    [super start];
    
    if (self.isCancelled){
        return;
    }
    [self changePropertyForSelector:@selector(isExecuting) withBlock:^{
        self->_executing = YES;
    }];
    
    [self executeRequest];
}

- (void)executeRequest
{
    self.task = [[[self class] session] dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.responseData = data;
        self.response = (NSHTTPURLResponse *)response;
        self.responseError = error;
        
        if (!error && self.response.statusCode > 299 && [data length] > 0){
            self.responseError = [NSError errorWithDomain:NSStringFromClass([self class]) code:self.response.statusCode userInfo:@{NSLocalizedDescriptionKey : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]}];
            self.responseData = nil;
        }
        
        [self finish];
    }];
    [self.task resume];
}

- (void)finish
{
    [self changePropertyForSelector:@selector(isExecuting) withBlock:^{
        self->_executing = NO;
    }];
    
    [self changePropertyForSelector:@selector(isFinished) withBlock:^{
        self->_finished = YES;
    }];
}

- (void)cancel
{
    [self.task cancel];
    
    [self changePropertyForSelector:@selector(isCancelled) withBlock:^{
        self->_cancelled = YES;
    }];
    
    [super cancel];
}

- (BOOL)isAsynchronous
{
    return YES;
}

- (BOOL)isExecuting
{
    return _executing;
}

- (BOOL)isFinished
{
    return _finished;
}

- (BOOL)isCancelled
{
    return _cancelled;
}

- (void)changePropertyForSelector:(SEL)selector withBlock:(void (^)(void))block
{
    [self willChangeValueForKey:NSStringFromSelector(selector)];
    block();
    [self didChangeValueForKey:NSStringFromSelector(selector)];
}

@end
