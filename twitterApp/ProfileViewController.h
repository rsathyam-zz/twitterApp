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
- (id)initWithUser:(User *)user;
@property (weak, nonatomic) IBOutlet UIImageView *profileHeaderImageView;
@property (strong, nonatomic) User* user;

@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *numTweetsLabel;

@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowedByLabel;


@end
