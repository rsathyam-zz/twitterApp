//
//  ProfileViewController.m
//  twitterApp
//
//  Created by Ravi Sathyam on 11/9/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Profile";
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:self.user.screenName,@"screen_name", nil];
    
    [[TwitterClient sharedInstance] getBannerURLWithParams:params completion:^(NSString *bannerURL, NSError *error) {
        if(error == nil) {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:bannerURL]];
            UIImage* image = [UIImage imageWithData:imageData];
            CGSize targetSize = self.bannerImageView.bounds.size;
            UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
            [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
            UIImage* resized = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [self.bannerImageView setImage:resized];
        }
    }];
    
    if (self.user.profilePic == nil) {
        NSURL* url = [NSURL URLWithString:[self.user.profileImageURL stringByReplacingOccurrencesOfString:@"_normal." withString:@"."]];
        NSURLRequest* profileURLRequest = [NSURLRequest requestWithURL:url];
        CGSize targetSize = self.profileImageView.bounds.size;
        [self.profileImageView setImageWithURLRequest:profileURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
            [image drawInRect:CGRectMake(0,0, targetSize.width, targetSize.height)];
            UIImage* resized = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [self.profileImageView setImage:resized];
            self.user.profilePic = resized;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        [self.profileImageView setImage:self.user.profilePic];
    }
    
    self.nameLabel.text = self.user.name;
    self.screennameLabel.text = [@"@" stringByAppendingString:self.user.screenName];
    NSNumber* tweetCount = self.user.userProperties[@"statuses_count"];
    self.numTweets.text = [tweetCount stringValue];
    
    NSNumber* followerCount = self.user.userProperties[@"followers_count"];
    self.numFollowers.text = [followerCount stringValue];
    
    NSNumber* friendCount = self.user.userProperties[@"friends_count"];
    self.numFollowing.text = [friendCount stringValue];
}

- (id)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
