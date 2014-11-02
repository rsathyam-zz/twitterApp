//
//  TwitterClient.h
//  twitterApp
//
//  Created by Ravi Sathyam on 10/27/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
+ (TwitterClient *)sharedInstance;
- (void)loginWithCompletion:(void (^)(User* user, NSError* error))completion;
- (void)openURL:(NSURL*)url;
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray* tweets, NSError* error))completion;

@property (nonatomic, strong) void (^loginCompletion)(User* user, NSError* error);
@end
