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
#import "NSURLComponents+FindQueryItem.h"

@interface Github ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, copy) NSString *accessToken; // TODO: If this was a real project, we'd store this in the keychain. But for now, we'll just ask for it if we don't have it

// TODO: if this was a real project, I'd figure out some way of handling this state better
@property (nonatomic, strong) NSString *postingComment;
@property (nonatomic, strong) Gist *postingGist;
@property (nonatomic, copy) void (^postingCompletion)(NSError *error);

@end

@implementation Github

+ (NSString *)clientID
{
    return @"";
}

+ (NSString *)clientSecret
{
    return @"";
}

+ (NSURL *)authorizeURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&scope=gist", [self clientID]]];
}

+ (NSURL *)accessTokenURLWithCode:(NSString *)code
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/login/oauth/access_token?client_id=%@&client_secret=%@&code=%@", [self clientID], [self clientSecret], code]];
}

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

- (void)postComment:(NSString *)comment toGist:(Gist *)gist completion:(void(^)(NSError *))completion
{
    if (self.accessToken){
        [self actuallyPostComment:comment toGist:gist completion:completion];
    } else {
        self.postingGist = gist;
        self.postingComment = comment;
        self.postingCompletion = completion;
    
        UIViewController *viewController = [self.delegate viewControllerForShowingGithubInterfaces];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Authentication Required", @"Authentication Required alert title") message:NSLocalizedString(@"In order to post this comment, you need to authenticate with Github.", @"Authentication Required alert body") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Authenticate", @"Authentication Required continue button title") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[Github authorizeURL] options:@{} completionHandler:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Authentication Required cancel button title") style:UIAlertActionStyleCancel handler:nil]];
        [viewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)actuallyPostComment:(NSString *)comment toGist:(Gist *)gist completion:(void(^)(NSError *))completion
{
    NSDictionary *body = @{@"body" : comment};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:gist.commentsURL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:body options:0 error:nil]];
    [self signRequest:request];
    
    __weak typeof(self) weakSelf = self;
    [self performHTTPRequest:request completion:^(id responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!error){
            [strongSelf fetchCommentsforGist:gist completion:^(NSArray * _Nonnull comments, NSError * _Nonnull error) {
                completion(error);
            }];
        } else {
            completion(error);
        }

        // Clear any cached values if there are any
        strongSelf.postingGist = nil;
        strongSelf.postingComment = nil;
        strongSelf.postingCompletion = nil;
    }];
}

- (void)fetchURL:(NSURL *)URL completion:(void(^)(id responseObject, NSError *error))completion
{
    return [self performHTTPRequest:[NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30] completion:completion];
}

- (void)performHTTPRequest:(NSURLRequest *)request completion:(void(^)(id responseObject, NSError *error))completion
{
    HTTPRequestOperation *operation = [[HTTPRequestOperation alloc] initWithRequest:request];
    
    __weak typeof(operation) weakOperation = operation;
    [operation setCompletionBlock:^{
        __strong typeof(weakOperation) strongOperation = weakOperation;
        id responseObject = strongOperation.responseData ? [NSJSONSerialization JSONObjectWithData:strongOperation.responseData options:0 error:nil] : nil;
        NSError *responseError = strongOperation.responseError;
        completion(responseObject, responseError);
    }];
    [self.operationQueue addOperation:operation];
}

- (NSMutableURLRequest *)signRequest:(NSMutableURLRequest *)request
{
    [request addValue:[NSString stringWithFormat:@"token %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    return request;
}

- (BOOL)handleAuthURL:(NSURL *)URL
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    NSString *code = [components queryItemWithName:@"code"];
    
    if (!code){
        return NO;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[self class] accessTokenURLWithCode:code]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    __weak typeof(self) weakSelf = self;
    [self performHTTPRequest:request completion:^(id responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (responseObject){
            strongSelf.accessToken = responseObject[@"access_token"];
            [strongSelf postComment:strongSelf.postingComment toGist:strongSelf.postingGist completion:strongSelf.postingCompletion];
        }
    }];
    return YES;
}

@end
