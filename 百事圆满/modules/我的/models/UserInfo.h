//
//  UserInfo.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/6/17.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString* ukey;
@property (nonatomic, strong) NSString* Mobile;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* Name;
@property (nonatomic, strong) NSString* IdNumber;
@property (nonatomic, strong) NSString* ProvincialId;
@property (nonatomic, strong) NSString* ProvincialName;
@property (nonatomic, strong) NSString* CityId;
@property (nonatomic, strong) NSString* CityName;
@property (nonatomic, strong) NSString* DistrictId;
@property (nonatomic, strong) NSString* Address;
@property (nonatomic, strong) NSString* Flg;
@property (nonatomic, strong) NSString* CarBrandSIG;
@property (nonatomic, strong) NSString* PartsUseForSIG;
@property (nonatomic, strong) NSString* Score;
@property (nonatomic, strong) NSString* Version;

+ (instancetype)currentUser;
+ (BOOL)isLogin;
+ (void)logout;
+ (NSString*)lastLoginUserImageURL;

- (void)login;
- (void)updateCurrentUser;
- (BOOL)updateHeadURL:(NSString*)url;

@end
