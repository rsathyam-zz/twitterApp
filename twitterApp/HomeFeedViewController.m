//
//  HomeFeedViewController.m
//  twitterApp
//
//  Created by Ravi Sathyam on 11/1/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "HomeFeedViewCell.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"

@interface HomeFeedViewController ()
@property UIRefreshControl *refreshControl;
@end

@implementation HomeFeedViewController
static HomeFeedViewCell* _sizingCell = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self.feedTableView registerNib:[UINib nibWithNibName:@"HomeFeedViewCell" bundle:nil] forCellReuseIdentifier:@"HomeFeedViewCell"];
    
    self.navigationItem.title = @"Home";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];

    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if (error == nil) {
            self.tweets = [[NSArray alloc] initWithArray:tweets];
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
    NSLog(@"Compose!!");
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
    return self.tweets.count;
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
    HomeFeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFeedViewCell"];
    
    Tweet* tweet = self.tweets[indexPath.row];
    cell.tweetTextLabel.text = tweet.text;
    [cell.tweetTextLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    
    cell.tweetUsernameLabel.text = [@"@" stringByAppendingString:tweet.creator.screenName];
    [cell.tweetUsernameLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
    cell.tweetNameLabel.text = tweet.creator.name;
    NSDate *date = tweet.createdAt;
    NSInteger delta = [date timeIntervalSinceNow];
    cell.tweetTimeLabel.text = [self getTimeStringFromDelta:delta];
    [cell.tweetNameLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
    [cell.tweetTimeLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
    
    NSURL* profilePictureURL = [NSURL URLWithString:[tweet.creator.profileImageURL stringByReplacingOccurrencesOfString:@"_normal.jpeg" withString:@".jpeg"]];
    NSURLRequest* profilePictureRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    CGSize targetSize = cell.tweetProfilePictureLabel.bounds.size;
    
    [cell.tweetProfilePictureLabel setImageWithURLRequest:profilePictureRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
        [image drawInRect:CGRectMake(0,0, targetSize.width, targetSize.height)];
        UIImage* resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [cell.tweetProfilePictureLabel setImage:resized];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //TODO UIAlertView
        NSLog(@"%@", error);
    }];
    
    // Configure the cell...
    
    return cell;
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
