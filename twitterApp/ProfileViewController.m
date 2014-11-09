//
//  ProfileViewController.m
//  twitterApp
//
//  Created by Ravi Sathyam on 11/9/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:self.user.screenName,@"screen_name", nil];
    
    [[TwitterClient sharedInstance] getBannerURLWithParams:params completion:^(NSString *bannerURL, NSError *error) {
        if(error == nil) {
            NSURL* url = [NSURL URLWithString:@"https://pbs.twimg.com/profile_banners/6253282/1347394302/mobile_retina"];
            NSURLRequest* bannerURLRequest = [NSURLRequest requestWithURL:url];
            CGSize targetSize = self.profileHeaderImageView.bounds.size;
            
            [self.profileHeaderImageView setImageWithURLRequest:bannerURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
                [image drawInRect:CGRectMake(0,0, targetSize.width, targetSize.height)];
                UIImage* resized = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [self.profileHeaderImageView setImage:resized];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                //TODO UIAlertView
                NSLog(@"%@", error);
            }];
            if (self.user.profilePic != nil) {
                [self.profilePhotoImageView setImage:self.user.profilePic];
            } else {
                NSURL* url = [NSURL URLWithString:[self.user.profileImageURL stringByReplacingOccurrencesOfString:@"_normal." withString:@"."]];
                NSURLRequest* profileURLRequest = [NSURLRequest requestWithURL:url];
                targetSize = self.profilePhotoImageView.bounds.size;
                [self.profilePhotoImageView setImageWithURLRequest:profileURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
                    [image drawInRect:CGRectMake(0,0, targetSize.width, targetSize.height)];
                    UIImage* resized = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    [self.profilePhotoImageView setImage:resized];
                    self.user.profilePic = resized;
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    NSLog(@"%@", error);
                }];
            }
            self.userNameLabel.text = self.user.name;
            
            self.userName.text = self.user.name;
            self.userScreenNameLabel.text = [@"@" stringByAppendingString:self.user.screenName];
            self.numTweetsLabel.text = self.user.userProperties[@"statuses_count"];
            self.numFollowersLabel.text = self.user.userProperties[@"followers_count"];
            self.numFollowedByLabel.text = self.user.userProperties[@"friends_count"];
                                                                
        }
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        self.user = user;
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
