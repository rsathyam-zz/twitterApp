//
//  TwitterClient.m
//  twitterApp
//
//  Created by Ravi Sathyam on 10/27/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString* const kTwitterConsumerKey = @"lpAuGEcLGlH5Z5IT6tud2Hnjg";
NSString* const kTwitterConsumerSecret = @"aSly9VOGURw3A9uNIPtQMUHeSNPjCTJ5RdplzMHA1MRPhod1PT";
NSString* const kTwitterBaseUrl = @"https://api.twitter.com";

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

- (void)loginWithCompletion:(void (^)(User* user, NSError* error))completion {
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the request token");
        NSURL* authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"Failed request token");
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL*)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User* user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"Current user: %@", user.userProperties[@"name"]);
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed getting current user");
            self.loginCompletion(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"Failed to get access token");
        self.loginCompletion(nil, error);
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray* tweets, NSError* error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray* tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //TODO: Show UIAlertView
        NSLog(@"%@", error);
        completion(nil, error);
    }];
}

- (void)composeMessageWithParams:(NSDictionary *)params completion:(void (^)(Tweet* tweet, NSError* error))completion {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet* tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(nil, error);
    }];
}

- (void)favoriteMessageWithParams:(NSDictionary *)params completion:(void(^)(NSError* error)) completion {
    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(error);
    }];
}

- (void)unfavoriteMessageWithParams:(NSDictionary *)params completion:(void(^)(NSError* error)) completion {
    [self POST:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(error);
    }];
}

- (void)retweetTweet:(Tweet *)tweet completion:(void(^)(Tweet* tweet, NSError* error)) completion {
    NSString* retweet_string = [NSString stringWithFormat:@"1.1/statuses/retweet/%ld.json", tweet.tweetID];
    [self POST:retweet_string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(nil, error);
    }];
}

- (void)unretweetTweet:(NSInteger)tweet_id completion:(void(^)(NSError* error)) completion {
    NSString* retweet_string = [NSString stringWithFormat:@"1.1/statuses/destroy/%ld.json", tweet_id];
    [self POST:retweet_string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(error);
    }];
}
- (void)getBannerURLWithParams:(NSDictionary *)params completion:(void(^)(NSString* bannerURL, NSError* error)) completion {
    [self GET:@"1.1/users/profile_banner.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* sizes = responseObject[@"sizes"];
        NSDictionary* mobile_retina = sizes[@"mobile_retina"];
        completion(mobile_retina[@"url"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching the bannerURL with params: %@", error);
        completion(nil, error);
    }];
}

@end
