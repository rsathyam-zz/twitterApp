//
//  User.h
//  twitterApp
//
//  Created by Ravi Sathyam on 10/29/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface User : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* screenName;
@property (nonatomic, strong) NSString* profileImageURL;
@property (nonatomic, strong) UIImage* profilePic;
@property (nonatomic, strong) NSString* tagLine;
@property (nonatomic, strong) NSDictionary* userProperties;


+ (User *)getCurrentUser;
+ (void)setCurrentUser:(User *)user;

@end
