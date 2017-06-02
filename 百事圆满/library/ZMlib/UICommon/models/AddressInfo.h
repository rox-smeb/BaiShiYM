//
//  AddressInfo.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/6/27.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject

@property (nonatomic, strong) NSString* AddressId;
@property (nonatomic, strong) NSString* SortId;
@property (nonatomic, strong) NSString* Name;
@property (nonatomic, strong) NSString* Telephone;
@property (nonatomic, strong) NSString* Provincial;
@property (nonatomic, strong) NSString* City;
@property (nonatomic, strong) NSString* District;
@property (nonatomic, strong) NSString* DetailAddress;
@property (nonatomic, assign) BOOL IsDefault;

@end
