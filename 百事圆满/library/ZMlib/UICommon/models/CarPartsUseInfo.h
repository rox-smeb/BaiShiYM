//
//  CarPartsUseInfo.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/4.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectModelProtocol.h"

/**
 *  配件子类型
 */
@interface CarPartsTypeInfo : NSObject <SelectModelProtocol>

@property (nonatomic, strong) NSString* PartsTypeId;
@property (nonatomic, strong) NSString* PartsTypeName;

@end

/**
 *  配件类型
 */
@interface CarPartsUseInfo : NSObject <SelectModelProtocol>

@property (nonatomic, strong) NSString* CarParstUseForId;
@property (nonatomic, strong) NSString* CarParstUseForName;
@property (nonatomic, strong) NSArray<CarPartsTypeInfo*>* PartsTypeList;

@end
