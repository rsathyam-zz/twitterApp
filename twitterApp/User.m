//
//  User.m
//  twitterApp
//
//  Created by Ravi Sathyam on 10/29/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "User.h"

@implementation User
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.userProperties = dictionary;
    }
    return self;
}

static User *_currentUser = nil;
NSString* const kCurrentUserKey = @"kCurrentUserKey";

+ (User *)getCurrentUser {
    if (_currentUser == nil) {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}
+ (void)setCurrentUser:(User *)user {
    _currentUser = user;
    
    if (_currentUser != nil) {
        NSData* data = [NSJSONSerialization dataWithJSONObject:user.userProperties options:0 error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
