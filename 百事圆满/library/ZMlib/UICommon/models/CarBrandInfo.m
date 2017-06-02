//
//  CarBrandInfo.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/4.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "CarBrandInfo.h"

@implementation CarModelInfo

#pragma mark - MultiSelectListDataSourceProtocol

- (NSString*)name
{
    return self.CarModelName;
}

@end

@implementation CarBrandInfo

- (NSDictionary*)objectPropertys
{
    return @{@"CarModelList" : [CarModelInfo class]};
}

#pragma mark - MultiSelectListDataSourceProtocol

- (NSString*)name
{
    return self.CarBrandName;
}

- (NSArray<id<SelectModelProtocol>>*)subList
{
    return self.CarModelList;
}

@end
