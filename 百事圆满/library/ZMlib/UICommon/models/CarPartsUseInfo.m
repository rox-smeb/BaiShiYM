//
//  CarPartsUseInfo.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/4.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "CarPartsUseInfo.h"

@implementation CarPartsTypeInfo

#pragma mark - MultiSelectListDataSourceProtocol

- (NSString*)name
{
    return self.PartsTypeName;
}

@end

@implementation CarPartsUseInfo

- (NSDictionary*)objectPropertys
{
    return @{@"PartsTypeList" : [CarPartsTypeInfo class]};
}

#pragma mark - MultiSelectListDataSourceProtocol

- (NSString*)name
{
    return self.CarParstUseForName;
}

- (NSArray<id<SelectModelProtocol>>*)subList
{
    return self.PartsTypeList;
}

@end
