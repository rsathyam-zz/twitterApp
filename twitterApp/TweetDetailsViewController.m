//
//  TweetDetailsViewController.m
//  twitterApp
//
//  Created by Ravi Sathyam on 11/2/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"

@interface TweetDetailsViewController ()

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.profileImageView setImage:self.tweet.profilePic];
    self.tweetLabel.text = self.tweet.text;
    [self.tweetLabel setFont:[UIFont fontWithName:@"Arial" size:17]];
    
    self.nameLabel.text = self.tweet.creator.name;
    [self.nameLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/y, HH:mm a"];
                            
    self.timeLabel.text = [formatter stringFromDate:self.tweet.createdAt];
    [self.timeLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    
    self.screenNameLabel.text = [@"@" stringByAppendingString:self.tweet.creator.screenName];
    [self.screenNameLabel setFont:[UIFont fontWithName:@"Arial" size:17]];
    
    self.favoritesLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favoriteCount];
    [self.favoritesLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    
    self.retweetsLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
    [self.retweetsLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    
    if (self.tweet.isRetweeted) {
        self.retweetButton.tintColor = [UIColor darkGrayColor];
    }
    
    if (self.tweet.isFavorited) {
        self.favoriteButton.tintColor = [UIColor darkGrayColor];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onReplyClicked:(id)sender {
    ComposeViewController* cvc = [[ComposeViewController alloc] init];
    cvc.user = self.tweet.creator;
    cvc.title = @"Reply";
    cvc.tweetIDForResponse = self.tweet.tweetID;
    cvc.composeTextView.text = self.screenNameLabel.text;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (IBAction)onRetweetClicked:(id)sender {
    if(self.tweet.isRetweeted == NO) {
        [[TwitterClient sharedInstance] retweetTweet:self.tweet completion:^(Tweet* tweet, NSError *error) {
        if (error != nil) {
            NSLog(@"Retweeting failed!");
        } else {
            NSInteger retweetCount = [self.retweetsLabel.text integerValue];
            retweetCount += 1;
            self.retweetsLabel.text = [NSString stringWithFormat:@"%ld", retweetCount];
            self.retweetButton.tintColor = [UIColor darkGrayColor];
            self.tweet.isRetweeted = YES;
            self.tweet.retweetID = tweet.tweetID;
        }
        }];
    } else {
        [[TwitterClient sharedInstance] unretweetTweet:self.tweet.retweetID completion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"unRetweeting failed!");
            } else {
                NSInteger retweetCount = [self.retweetsLabel.text integerValue];
                retweetCount -= 1;
                self.retweetsLabel.text = [NSString stringWithFormat:@"%ld", retweetCount];
                self.retweetButton.tintColor = [UIColor lightGrayColor];
                self.tweet.isRetweeted = NO;
            }
        }];
    }
}

- (IBAction)onFavoriteClicked:(id)sender {
    if (self.tweet.isFavorited == NO) {
        NSDictionary* params = @{@"id": [NSNumber numberWithLong: self.tweet.tweetID]};
        [[TwitterClient sharedInstance] favoriteMessageWithParams:params completion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Favoriting failed!");
            } else {
                NSInteger favoritesCount = [self.favoritesLabel.text integerValue];
                favoritesCount += 1;
                self.favoritesLabel.text = [NSString stringWithFormat:@"%ld", favoritesCount];
                self.favoriteButton.tintColor = [UIColor darkGrayColor];
                self.tweet.isFavorited = YES;
            }
        }];
    } else {
        NSDictionary* params = @{@"id": [NSNumber numberWithLong: self.tweet.tweetID]};
        [[TwitterClient sharedInstance] unfavoriteMessageWithParams:params completion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Unfavoriting failed!");
            } else {
                NSInteger favoritesCount = [self.favoritesLabel.text integerValue];
                favoritesCount -= 1;
                self.favoritesLabel.text = [NSString stringWithFormat:@"%ld", favoritesCount];
                self.favoriteButton.tintColor = [UIColor lightGrayColor];
                self.tweet.isFavorited = NO;
            }
        }];
    }
 }

- (id)initWithTweet:(Tweet *)tweet {
    self = [super init];
    if (self) {
        self.tweet = tweet;
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
