//
//  Tweet.h
//  twitterApp
//
//  Created by Ravi Sathyam on 10/29/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
- (id)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) User* creator;
@property (nonatomic, strong) UIImage* profilePic;
@property NSInteger retweetCount;
@property NSInteger favoriteCount;
+ (NSArray *)tweetsWithArray:(NSArray *)array;
@end
