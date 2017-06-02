//
//  UserInfo.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/6/17.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "UserInfo.h"

#define CURRENT_USER                (@"CURRENT_USER")
#define LAST_LOGIN_USER_HEAD        (@"LAST_LOGIN_USER_HEAD")

@implementation UserInfo

static UserInfo* currentUserInfo;

+ (instancetype)currentUser
{
    if (currentUserInfo == nil)
    {
        currentUserInfo = (UserInfo*)[[TMDiskCache sharedCache] objectForKey:CURRENT_USER];
    }
    
    return currentUserInfo;
}

+ (BOOL)isLogin
{
    UserInfo* info = [[self class] currentUser];
    if (info != nil)
    {
        return YES;
    }
    return NO;
}

+ (void)logout
{
    [[TMDiskCache sharedCache] removeObjectForKey:CURRENT_USER];
    currentUserInfo = nil;
}

+ (NSString*)lastLoginUserImageURL
{
    NSString* url = (NSString*)[[TMDiskCache sharedCache] objectForKey:LAST_LOGIN_USER_HEAD];
    return url;
}

- (void)login
{
    currentUserInfo = nil;
    [[TMDiskCache sharedCache] setObject:self forKey:CURRENT_USER];
    [[TMDiskCache sharedCache] setObject:self.url forKey:LAST_LOGIN_USER_HEAD];
}

- (void)updateCurrentUser
{
    [self login];
}

- (BOOL)updateHeadURL:(NSString*)url
{
    if ([url isKindOfClass:[NSString class]])
    {
        self.url = url;
        [[TMDiskCache sharedCache] setObject:self forKey:CURRENT_USER];
        [[TMDiskCache sharedCache] setObject:self.url forKey:LAST_LOGIN_USER_HEAD];
        return YES;
    }
    return NO;
}

- (NSDictionary*)objectPropertys
{
    return @{@"ukey" : @"Ukey",
             @"url"  : @"Url"};
}

@end

