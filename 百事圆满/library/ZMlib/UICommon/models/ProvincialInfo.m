//
//  ProvincialInfo.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/6.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "ProvincialInfo.h"

@implementation ProvincialCityInfo

@end

@implementation ProvincialInfo

- (NSDictionary*)objectPropertys
{
    return @{@"CityList" : [ProvincialCityInfo class]};
}

@end
