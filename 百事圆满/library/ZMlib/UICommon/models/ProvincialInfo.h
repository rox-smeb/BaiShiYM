//
//  ProvincialInfo.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/6.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvincialCityInfo : NSObject

@property (nonatomic, strong) NSString* CityId;
@property (nonatomic, strong) NSString* CityName;
@property (nonatomic, strong) NSArray* DistrictList;

@end

@interface ProvincialInfo : NSObject

@property (nonatomic, strong) NSString* ProvincialId;
@property (nonatomic, strong) NSString* ProvincialName;
@property (nonatomic, strong) NSArray<ProvincialCityInfo*>* CityList;

@end
