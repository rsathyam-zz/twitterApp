//
//  HomeFeedViewCell.m
//  twitterApp
//
//  Created by Ravi Sathyam on 11/1/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "HomeFeedViewCell.h"
#import "ComposeViewController.h"

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
}

- (IBAction)onFavoriteClicked:(id)sender {
}
@end
