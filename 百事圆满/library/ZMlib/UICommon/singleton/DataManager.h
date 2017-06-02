//
//  DataManager.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/6/22.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityListViewController.h"
#import "CarBrandInfo.h"                        // 品牌车型
#import "CarPartsUseInfo.h"                     // 配件类型
#import "RepairBrandInfo.h"                     // 维修品牌
#import "RepairProjectInfo.h"                   // 维修项目
#import "AddressInfo.h"

#define DEFAULT_CITY_NAME                       (@"哈尔滨市")
#define USER_DEFAULT_ADDRESS_INFO               (@"USER_DEFAULT_ADDRESS_INFO")
#define CURRENT_LOCATION_CITY_NAME              (@"CurrentLocationCityName")                    // 当前定位城市名称
#define CURRENT_SELECTED_CITY_NAME              (@"CurrentSelectedCityName")                    // 当前选择城市名称

@interface DataManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  更新当前选择的城市
 *
 *  @param cityName 城市名
 */
- (void)updateCurrentSelectedCity:(NSString*)cityName;

/**
 *  获取当前选择的城市
 *
 *  @return 城市名
 */
- (NSString*)currentSelectedCity;

/**
 *  获取当前选择的城市信息
 *
 *  @return 城市信息
 */
- (CityInfo*)currentSelectedCityInfo;

/**
 *  更新当前定位到的城市
 *
 *  @param cityName 城市名
 */
- (void)upateCurrentLocationCity:(NSString*)cityName;

/**
 *  获取当前定位的城市
 *
 *  @return 城市名
 */
- (NSString*)currentLocationCity;

/**
 *  获取当前定位的城市信息
 *
 *  @return 城市信息
 */
- (CityInfo*)currentLocationCityInfo;

/**
 *  通过城市名称查询城市信息
 *
 *  @param name 城市名称
 *
 *  @return 城市信息
 */
- (CityInfo*)cityInfoWithName:(NSString*)name;

/**
 *  默认城市信息
 *
 *  @return 城市信息
 */
- (CityInfo*)defaultCityInfo;

/**
 *  城市列表
 *
 *  @return 列表
 */
- (NSArray<CityInfo*>*)cityList;

/**
 *  品牌车型列表
 *
 *  @return 列表
 */
- (NSArray<CarBrandInfo*>*)carBrandList;

/**
 *  配件类型列表
 *
 *  @return 列表
 */
- (NSArray<CarPartsUseInfo*>*)carPartsUseList;

/**
 *  维修品牌列表
 *
 *  @return 列表
 */
- (NSArray<RepairBrandInfo*>*)repairBrandList;

/**
 *  维修项目列表
 *
 *  @return 列表
 */
- (NSArray<RepairProjectInfo*>*)repairProjectList;

/**
 *  更新默认收货地址
 *
 *  @param info AddressInfo
 */
- (void)updateDefaultDeliverAddressInfo:(AddressInfo*)info;

/**
 *  清空默认收货地址
 */
- (void)removeDefaultDeliverAddress;

/**
 *  获取默认收货地址
 *
 *  @return AddressInfo
 */
- (AddressInfo*)defaultDeliverAddressInfo;

/**
 *  通过品牌车型名称反查ID
 *
 *  @param sig "名称1,名称2"
 *
 *  @return 反查出的ID列表
 */
- (NSMutableArray<NSString*>*)carBrandIdsWithSIG:(NSString*)sig;

/**
 *  通过品牌车型名称反查ID
 *
 *  @param sig "名称1,名称2"
 *
 *  @return 反查出的ID列表
 */
- (NSMutableArray<NSString*>*)carPartsUseForIdsWithSIG:(NSString*)sig;

@end
