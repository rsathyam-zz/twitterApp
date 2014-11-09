//
//  ProfileViewController.h
//  twitterApp
//
//  Created by Ravi Sathyam on 11/9/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (strong, nonatomic) User* user;
- (id)initWithUser:(User *)user;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numTweets;

@property (weak, nonatomic) IBOutlet UILabel *numFollowers;

@property (weak, nonatomic) IBOutlet UILabel *numFollowing;


@end
