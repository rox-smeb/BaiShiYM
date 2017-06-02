//
//  CarBrandInfo.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/4.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectModelProtocol.h"

/**
 *  品牌子类型
 */
@interface CarModelInfo : NSObject <SelectModelProtocol>

@property (nonatomic, strong) NSString* CarModelId;
@property (nonatomic, strong) NSString* CarModelName;

@end

/**
 *  品牌类型
 */
@interface CarBrandInfo : NSObject <SelectModelProtocol>

@property (nonatomic, strong) NSString* CarBrandId;
@property (nonatomic, strong) NSString* CarBrandName;
@property (nonatomic, strong) NSArray<CarModelInfo*>* CarModelList;

@end
