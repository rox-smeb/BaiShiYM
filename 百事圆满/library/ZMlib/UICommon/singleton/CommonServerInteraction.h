//
//  CommonServerInteraction.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/6.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProvincialInfo.h"

@interface CommonServerInteraction : YBServerInteraction

+ (CommonServerInteraction*)sharedInstance;

/**
 *  获取省市区信息
 *
 *  @param responseBlock 成功回调 (NSArray<ProvincialInfo*>*)
 */
- (void)provincialInfoResponseBlock:(YBResponseBlock)responseBlock;

@end
