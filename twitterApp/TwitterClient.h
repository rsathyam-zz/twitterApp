//
//  TwitterClient.h
//  twitterApp
//
//  Created by Ravi Sathyam on 10/27/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
+ (TwitterClient *)sharedInstance;
@end
