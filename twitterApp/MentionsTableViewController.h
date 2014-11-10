//
//  MentionsTableViewController.h
//  twitterApp
//
//  Created by Ravi Sathyam on 11/9/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MentionsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableView *mentionsTableView;
@property (nonatomic, strong) NSArray* tweets;
- (NSString* )getTimeStringFromDelta:(NSInteger)delta;
@end
