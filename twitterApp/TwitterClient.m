//
//  TwitterClient.m
//  twitterApp
//
//  Created by Ravi Sathyam on 10/27/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "TwitterClient.h"

NSString* const kTwitterConsumerKey = @"";
NSString* const kTwitterConsumerSecret = @"";
NSString* const kTwitterBaseUrl = @"https://api.twitter.com";

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] init];
        }
    });
    
    return instance;
}
@end
