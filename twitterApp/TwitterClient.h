//
//  TwitterClient.h
//  twitterApp
//
//  Created by Ravi Sathyam on 10/27/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
+ (TwitterClient *)sharedInstance;
- (void)loginWithCompletion:(void (^)(User* user, NSError* error))completion;
- (void)openURL:(NSURL*)url;
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray* tweets, NSError* error))completion;
- (void)composeMessageWithParams:(NSDictionary*)params completion:(void (^)(Tweet* tweet, NSError* error))completion;
- (void)retweetTweet:(Tweet *)tweet completion:(void(^)(Tweet* tweet, NSError* error)) completion;
- (void)unretweetTweet:(NSInteger)tweet_id completion:(void(^)(NSError* error)) completion;
- (void)favoriteMessageWithParams:(NSDictionary *)params completion:(void (^)(NSError* error))completion;
- (void)unfavoriteMessageWithParams:(NSDictionary *)params completion:(void(^)(NSError* error)) completion;
- (void)getBannerURLWithParams:(NSDictionary *)params completion:(void(^)(NSString* bannerURL, NSError* error)) completion;
@property (nonatomic, strong) void (^loginCompletion)(User* user, NSError* error);
@end