//
//  ComposeViewController.h
//  twitterApp
//
//  Created by Ravi Sathyam on 11/2/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ComposeViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;
@property (weak, nonatomic) IBOutlet UILabel *charactersRemainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numCharsLabel;
@property (nonatomic, strong) User* user;
@property NSInteger tweetIDForResponse;
@end
