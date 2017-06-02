//
//  RepairProjectInfo.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/10.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "RepairProjectInfo.h"

@implementation RepairProjectInfo

#pragma mark - MultiSelectListDataSourceProtocol

- (NSString*)name
{
    return self.Name;
}

- (NSArray<id<SelectModelProtocol>>*)subList
{
    return nil;
}

@end
