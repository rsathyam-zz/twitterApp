//
//  HomeViewController.h
//  twitterApp
//
//  Created by Ravi Sathyam on 11/5/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "HomeFeedViewCell.h"
#import "HomeFeedViewController.h"
#import "HamburberTableTableViewController.h"

@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *feedView;
@property (weak, nonatomic) IBOutlet UIView *hamburgerView;

@property (weak, nonatomic) IBOutlet UITableView *hamburgerTableView;
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;


@property (nonatomic, strong) NSArray* tweets;
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) HomeFeedViewCell* prototypeCell;
- (id)initWithUser:(User *)user;
@end
