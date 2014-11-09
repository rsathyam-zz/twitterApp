//
//  HomeFeedViewController.m
//  twitterApp
//
//  Created by Ravi Sathyam on 11/1/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeFeedViewCell.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetDetailsViewController.h"
#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "LoginViewController.h"
#import "ProfileViewCell.h"

@interface HomeViewController ()
@property UIRefreshControl *refreshControl;
@end

@implementation HomeViewController
static HomeFeedViewCell* _sizingCell = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    
    self.hamburgerTableView.delegate = self;
    self.hamburgerTableView.dataSource = self;    
    
    UIPanGestureRecognizer* hamburgerHider = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onHamburgerHide:)];
    [self.hamburgerView addGestureRecognizer:hamburgerHider];
    UIPanGestureRecognizer* hamburgerShower = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onHamburgerShow:)];
    [self.feedView addGestureRecognizer:hamburgerShower];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self.feedTableView registerNib:[UINib nibWithNibName:@"HomeFeedViewCell" bundle:nil] forCellReuseIdentifier:@"HomeFeedViewCell"];
    
    [self.hamburgerTableView registerNib:[UINib nibWithNibName:@"ProfileViewCell" bundle:nil] forCellReuseIdentifier:@"ProfileViewCell"];
    
    self.navigationItem.title = @"Home";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if (error == nil) {
            //Fetch the tweet from cache
            NSCache *cache = [[NSCache alloc]init];
            Tweet* tweet = [cache objectForKey:@"new_tweet"];
            NSMutableArray *mutableTweets = [[NSMutableArray alloc] init];
            if (tweet != nil) {
                [mutableTweets addObject:tweet]; 
            }
            [mutableTweets addObjectsFromArray:tweets];
            self.tweets = [[NSArray alloc] initWithArray:mutableTweets];
            [self.feedTableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)onComposeButton {
    ComposeViewController* cvc = [[ComposeViewController alloc] init];
    cvc.user = [User getCurrentUser];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)onLogoutButton {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    LoginViewController* lvc = [[LoginViewController alloc] init];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark - UIRefreshControl
- (void)onRefresh
{
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if (error == nil) {
            self.tweets = [[NSArray alloc] initWithArray:tweets];
            [self.feedTableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error);
        }
    }];
}


- (void)onHamburgerHide:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.hamburgerView];
    
    if (velocity.x > 0) {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = self.feedView.frame;
            frame.origin.x = 0;
            self.feedView.frame = frame;
        }];
    }
}

- (void)onHamburgerShow:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.feedView];
    
    if (velocity.x < 0) {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = self.feedView.frame;
            frame.origin.x = -frame.size.width;
            self.feedView.frame = frame;
        }];
    }
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.feedTableView) {
        return self.tweets.count;
    }
    return 3;
}

- (NSString* )getTimeStringFromDelta:(NSInteger)delta {
    NSInteger abs_delta = labs(delta);
    
    NSInteger abs_days = abs_delta / (60 * 60 * 24);
    if (abs_days > 0) {
        return [NSString stringWithFormat:@"%ldd", (long)abs_days];
    }
    abs_delta -= abs_days * (60 * 60 * 24);
    NSInteger abs_hours = abs_delta / (60 * 60);
    if (abs_hours > 0) {
        return [NSString stringWithFormat:@"%ldh", (long)abs_hours];
    }
    abs_delta -= abs_hours * (60 * 60);
    NSInteger abs_minutes = abs_delta / 60;
    if (abs_minutes > 0) {
        return [NSString stringWithFormat:@"%ldm", (long)abs_minutes];
    } else {
        return [NSString stringWithFormat:@"%lds", (long)abs_delta];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.feedTableView) {
        HomeFeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFeedViewCell"];
    
        Tweet* tweet = self.tweets[indexPath.row];
        cell.tweetTextLabel.text = tweet.text;
        [cell.tweetTextLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
    
        cell.tweetUsernameLabel.text = [@"@" stringByAppendingString:tweet.creator.screenName];
        [cell.tweetUsernameLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
        cell.tweetNameLabel.text = tweet.creator.name;
        NSDate *date = tweet.createdAt;
        NSInteger delta = [date timeIntervalSinceNow];
        cell.tweetTimeLabel.text = [self getTimeStringFromDelta:delta];
        [cell.tweetNameLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
        [cell.tweetTimeLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
    
        cell.navController = self.navigationController;
        cell.tweet = tweet;
    
        if (tweet.isFavorited) {
            cell.favoriteButton.tintColor = [UIColor darkGrayColor];
        }
    
        if (tweet.isRetweeted) {
            cell.retweetButton.tintColor = [UIColor darkGrayColor];
        }
    
        NSURL* profilePictureURL = [NSURL URLWithString:[tweet.creator.profileImageURL stringByReplacingOccurrencesOfString:@"_normal." withString:@"."]];
        NSURLRequest* profilePictureRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
        CGSize targetSize = cell.tweetProfilePictureLabel.bounds.size;
    
        [cell.tweetProfilePictureLabel setImageWithURLRequest:profilePictureRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
            [image drawInRect:CGRectMake(0,0, targetSize.width, targetSize.height)];
            UIImage* resized = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [cell.tweetProfilePictureLabel setImage:resized];
            tweet.profilePic = resized;
            tweet.creator.profilePic = resized;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //TODO UIAlertView
            NSLog(@"%@", error);
        }];
        return cell;
    } else {
        ProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileViewCell"];
        
        if (indexPath.row == 0) {
            cell.screennameLabel.text = @"View Profile";
        } else if (indexPath.row == 1) {
            cell.screennameLabel.text = @"View Timeline";
        } else {
            cell.screennameLabel.text = @"View Mentions";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.feedTableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailsViewController* tdvc = [[TweetDetailsViewController alloc] initWithTweet:self.tweets[indexPath.row]];
    [self.navigationController pushViewController:tdvc animated:YES];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
