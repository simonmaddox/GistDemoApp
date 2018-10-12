//
//  Github.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "Github.h"
#import "HTTPRequestOperation.h"
#import "Gist.h"
#import "Comment.h"

@interface Github ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation Github

+ (NSString *)gistIDFromURL:(NSURL *)URL
{
    return [self gistIDFromURLString:[URL absoluteString]];
}

+ (NSString *)gistIDFromURLString:(NSString *)URLString
{
    NSURLComponents *components = [NSURLComponents componentsWithString:URLString];
    
    if (![components.host isEqualToString:@"gist.github.com"]){
        return nil;
    }
        
    // TODO: Are there any more checks we can do to ensure this is a gist URL?
    
    return [components.path lastPathComponent];
}

+ (NSURL *)APIURLForGistID:(NSString *)identifier
{
    return [[NSURL URLWithString:@"https://api.github.com/gists/"] URLByAppendingPathComponent:identifier];
}

- (instancetype)init
{
    if (self = [super init]){
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)fetchGistWithURL:(NSURL *)gistURL completion:(void(^)(Gist *gist, NSError *error))completion
{
    [self fetchURL:[[self class] APIURLForGistID:[[self class] gistIDFromURL:gistURL]] completion:^(id responseObject, NSError *error) {
        if (error){
            completion(nil, error);
            return;
        }
        
        Gist *gist = [Gist objectFromDictionary:responseObject];
        [self fetchCommentsforGist:gist completion:^(NSArray * _Nonnull comments, NSError * _Nonnull error) {
            gist.comments = comments;
            completion(gist, error);
        }];
    }];
}

- (void)fetchCommentsforGist:(Gist *)gist completion:(void(^)(NSArray *comments, NSError *error))completion
{
    [self fetchURL:gist.commentsURL completion:^(id responseObject, NSError *error) {
        if (error){
            completion(nil, error);
            return;
        }
        
        NSArray <Comment *> *comments = [Comment objectsFromArray:responseObject];
        gist.comments = comments;
        completion(comments, error);
        
    }];
}

- (void)fetchURL:(NSURL *)URL completion:(void(^)(id responseObject, NSError *error))completion
{
    return [self performHTTPRequest:[NSURLRequest requestWithURL:URL] completion:completion];
}

- (void)performHTTPRequest:(NSURLRequest *)request completion:(void(^)(id responseObject, NSError *error))completion
{
    HTTPRequestOperation *operation = [[HTTPRequestOperation alloc] initWithRequest:request];
    
    __weak typeof(operation) weakOperation = operation;
    [operation setCompletionBlock:^{
        __strong typeof(weakOperation) strongOperation = weakOperation;
        id responseObject = [NSJSONSerialization JSONObjectWithData:strongOperation.responseData options:0 error:nil] ?: nil;
        NSError *responseError = strongOperation.responseError;
        completion(responseObject, responseError);
    }];
    [self.operationQueue addOperation:operation];
}

@end
