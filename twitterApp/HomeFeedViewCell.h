//
//  HomeFeedViewCell.h
//  twitterApp
//
//  Created by Ravi Sathyam on 11/1/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeFeedViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tweetTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetProfilePictureLabel;


@end
