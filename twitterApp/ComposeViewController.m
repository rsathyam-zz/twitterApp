//
//  ComposeViewController.m
//  twitterApp
//
//  Created by Ravi Sathyam on 11/2/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.composeTextView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    NSURL* profilePictureURL = [NSURL URLWithString:[self.user.profileImageURL stringByReplacingOccurrencesOfString:@"_normal.jpeg" withString:@".jpeg"]];
    NSURLRequest* profilePictureRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    CGSize targetSize = self.profilePicView.bounds.size;
    
    [self.profilePicView setImageWithURLRequest:profilePictureRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
        [image drawInRect:CGRectMake(0,0, targetSize.width, targetSize.height)];
        UIImage* resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.profilePicView setImage:resized];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //TODO UIAlertView
        NSLog(@"%@", error);
    }];
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [@"@" stringByAppendingString:self.user.screenName];
    if (self.tweetIDForResponse > 0) {
        self.navigationItem.title = @"Reply";
        self.composeTextView.text = [@"@" stringByAppendingString:[NSString stringWithFormat:@"%@ ", self.user.screenName]];
    } else {
        self.navigationItem.title = @"Compose";
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
}

- (void)onCancelButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTweetButton {
    NSDictionary* params =
        [[NSDictionary alloc] initWithObjectsAndKeys:self.composeTextView.text,@"status",
          [NSNumber numberWithInteger:self.tweetIDForResponse],@"in_reply_to_status_id",
          nil
        ];
    [[TwitterClient sharedInstance] composeMessageWithParams:params completion:^(NSError *error){
        if (error != nil) {
            NSLog(@"(Compose failed!");
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        };
    }];
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
