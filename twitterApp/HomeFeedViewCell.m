//
//  HomeFeedViewCell.m
//  twitterApp
//
//  Created by Ravi Sathyam on 11/1/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "HomeFeedViewCell.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"

@implementation HomeFeedViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onReplyClicked:(id)sender {
    ComposeViewController* cvc = [[ComposeViewController alloc] init];
    cvc.user = self.tweet.creator;
    cvc.title = @"Reply";
    cvc.tweetIDForResponse = self.tweet.tweetID;
    cvc.composeTextView.text = self.tweetUsernameLabel.text;
    [self.navController pushViewController:cvc animated:YES];
}

- (IBAction)onRetweetClicked:(id)sender {
    if (!self.tweet.isRetweeted) {
        [[TwitterClient sharedInstance] retweetTweet:self.tweet completion:^(Tweet* tweet, NSError *error) {
            if (error != nil) {
                NSLog(@"Retweeting failed!");
            } else {
                self.retweetButton.tintColor = [UIColor darkGrayColor];
                self.tweet.isRetweeted = YES;
                self.tweet.retweetID = tweet.tweetID;
            }
        }];
    } else {
        [[TwitterClient sharedInstance] unretweetTweet:self.tweet.retweetID completion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"unetweeting failed!");
            } else {
                self.retweetButton.tintColor = [UIColor lightGrayColor];
                self.tweet.isRetweeted = NO;
            }
        }];
    }
}

- (IBAction)onFavoriteClicked:(id)sender {
    NSDictionary* params = @{@"id": [NSNumber numberWithLong: self.tweet.tweetID]};
    if (!self.tweet.isFavorited) {
        [[TwitterClient sharedInstance] favoriteMessageWithParams:params completion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Favoriting failed!");
            } else {
                self.tweet.isFavorited = YES;
            self.favoriteButton.tintColor = [UIColor darkGrayColor];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] unfavoriteMessageWithParams:params completion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Unfavoriting failed!");
            } else {
                self.tweet.isFavorited = NO;
                self.favoriteButton.tintColor = [UIColor lightGrayColor];
            }
        }];
    }
}
- (IBAction)onImageButtonClicked:(id)sender {
}
@end
