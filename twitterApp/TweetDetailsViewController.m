//
//  TweetDetailsViewController.m
//  twitterApp
//
//  Created by Ravi Sathyam on 11/2/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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