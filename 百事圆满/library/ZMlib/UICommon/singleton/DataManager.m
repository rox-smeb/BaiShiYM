//
//  DataManager.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/6/22.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()

@property (nonatomic, strong) NSMutableArray* cityInfoArray;                    // 城市列表
@property (nonatomic, strong) NSMutableArray* carBrandInfoArray;                // 品牌车型列表
@property (nonatomic, strong) NSMutableArray* carPartsUseInfoArray;             // 配件类型列表
@property (nonatomic, strong) NSMutableArray* repairBrandInfoArray;             // 维修品牌列表
@property (nonatomic, strong) NSMutableArray* repairProjectInfoArray;           // 维修项目列表

@end

@implementation DataManager

static DataManager *SINGLETON = nil;

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SINGLETON = [[super alloc] init];
    });
    
    return SINGLETON;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)updateCurrentSelectedCity:(NSString*)cityName
{
    if ([cityName isAvailability])
    {
        [[TMDiskCache sharedCache] setObject:cityName forKey:CURRENT_SELECTED_CITY_NAME];
    }
}

- (NSString*)currentSelectedCity
{
    NSString* city = (NSString*)[[TMDiskCache sharedCache] objectForKey:CURRENT_SELECTED_CITY_NAME];
    if ([city isKindOfClass:[NSString class]])
    {
        return city;
    }
    return nil;
}

- (CityInfo*)currentSelectedCityInfo
{
    NSString* cityName = [self currentSelectedCity];
    CityInfo* cityInfo = [self cityInfoWithName:cityName];
    return cityInfo;
}

- (void)upateCurrentLocationCity:(NSString*)cityName
{
    if ([cityName isAvailability])
    {
        [[TMDiskCache sharedCache] setObject:cityName forKey:CURRENT_LOCATION_CITY_NAME];
    }
}

- (NSString*)currentLocationCity
{
    NSString* city = (NSString*)[[TMDiskCache sharedCache] objectForKey:CURRENT_LOCATION_CITY_NAME];
    if ([city isKindOfClass:[NSString class]])
    {
        return city;
    }
    return nil;
}

- (CityInfo*)currentLocationCityInfo
{
    NSString* cityName = [self currentLocationCity];
    CityInfo* cityInfo = [self cityInfoWithName:cityName];
    return cityInfo;
}

- (CityInfo*)cityInfoWithName:(NSString*)name
{
    CityInfo* result = nil;
    @try
    {
        if (name != nil)
        {
            NSArray* cityList = [self cityList];
            for (CityInfo* info in cityList)
            {
                if ([info.Name isEqualToString:name])
                {
                    result = info;
                    break;
                }
            }
        }
    }
    @catch (NSException *exception)
    {
        
    }
    return result;
}

- (CityInfo*)defaultCityInfo
{
    return [self cityInfoWithName:DEFAULT_CITY_NAME];
}

- (NSMutableArray*)arrayWithFileName:(NSString*)fileName type:(NSString*)type class:(Class)aClass
{
    NSMutableArray* list = [NSMutableArray array];
    @try
    {
        NSError* error = nil;
        NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
        NSString* json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        NSArray* tmp = [NSArray arrayWithJSON:json];
        
        for (NSDictionary* dict in tmp)
        {
            NSObject* info = [[aClass alloc] initWithJSON:dict];
            if (info != nil)
            {
                [list addObject:info];
            }
        }
    }
    @catch (NSException *exception)
    {
    }
    return list;
}

- (NSArray<CityInfo*>*)cityList
{
    if (self.cityInfoArray == nil)
    {
        self.cityInfoArray = [self arrayWithFileName:@"CityFile" type:@"json" class:[CityInfo class]];
    }
    return self.cityInfoArray;
}

- (NSArray<CarBrandInfo*>*)carBrandList
{
    if (self.carBrandInfoArray == nil)
    {
        self.carBrandInfoArray = [self arrayWithFileName:@"PartsCarModel" type:@"json" class:[CarBrandInfo class]];
    }
    return self.carBrandInfoArray;
}

- (NSArray<CarPartsUseInfo*>*)carPartsUseList
{
    if (self.carPartsUseInfoArray == nil)
    {
        self.carPartsUseInfoArray = [self arrayWithFileName:@"Parts" type:@"json" class:[CarPartsUseInfo class]];
    }
    return self.carPartsUseInfoArray;
}

- (NSArray<RepairBrandInfo*>*)repairBrandList
{
    if (self.repairBrandInfoArray == nil)
    {
        self.repairBrandInfoArray = [self arrayWithFileName:@"CarBrand" type:@"json" class:[RepairBrandInfo class]];
    }
    return self.repairBrandInfoArray;
}

- (NSArray<RepairProjectInfo*>*)repairProjectList
{
    if (self.repairProjectInfoArray == nil)
    {
        self.repairProjectInfoArray = [self arrayWithFileName:@"PartsUseFor" type:@"json" class:[RepairProjectInfo class]];
    }
    return self.repairProjectInfoArray;
}

- (void)updateDefaultDeliverAddressInfo:(AddressInfo*)info
{
    if ([info isKindOfClass:[AddressInfo class]])
    {
        [[TMDiskCache sharedCache] setObject:info forKey:USER_DEFAULT_ADDRESS_INFO];
    }
}

- (void)removeDefaultDeliverAddress
{
    [[TMDiskCache sharedCache] removeObjectForKey:USER_DEFAULT_ADDRESS_INFO];
}

- (AddressInfo*)defaultDeliverAddressInfo
{
    AddressInfo* info = (AddressInfo*)[[TMDiskCache sharedCache] objectForKey:USER_DEFAULT_ADDRESS_INFO];
    if ([info isKindOfClass:[AddressInfo class]])
    {
        return info;
    }
    return nil;
}

- (NSMutableArray<NSString*>*)carBrandIdsWithSIG:(NSString*)sig
{
    NSMutableSet* set = [NSMutableSet set];
    NSArray* sigArray = [sig componentsSeparatedByString:@","];
    for (NSString* item in sigArray)
    {
        if (item != nil)
        {
            [set addObject:item];
        }
    }
    
    NSMutableArray* array = [NSMutableArray array];
    NSArray* carBrandArray = [self carBrandList];
    
    for (CarBrandInfo* info in carBrandArray)
    {
        if (info.CarBrandId != nil && info.CarBrandName)
        {
            if ([set containsObject:info.CarBrandName])
            {
                [array addObject:info.CarBrandId];
            }
        }
    }
    return array;
}

- (NSMutableArray<NSString*>*)carPartsUseForIdsWithSIG:(NSString*)sig
{
    NSMutableSet* set = [NSMutableSet set];
    NSArray* sigArray = [sig componentsSeparatedByString:@","];
    for (NSString* item in sigArray)
    {
        if (item != nil)
        {
            [set addObject:item];
        }
    }
    
    NSMutableArray* array = [NSMutableArray array];
    NSArray* carPartsUsrForArray = [self carPartsUseList];
    
    for (CarPartsUseInfo* info in carPartsUsrForArray)
    {
        if (info.CarParstUseForId != nil && info.CarParstUseForName)
        {
            if ([set containsObject:info.CarParstUseForName])
            {
                [array addObject:info.CarParstUseForId];
            }
        }
    }
    return array;
}

@end
