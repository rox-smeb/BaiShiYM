//
//  RepairBrandInfo.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/10.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectModelProtocol.h"

@interface RepairBrandInfo : NSObject <SelectModelProtocol>

@property (nonatomic, strong) NSString* CarBrandId;
@property (nonatomic, strong) NSString* Name;

@end
