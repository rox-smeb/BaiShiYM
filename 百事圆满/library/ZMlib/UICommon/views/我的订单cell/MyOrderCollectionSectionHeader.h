//
//  MyOrderCollectionSectionHeader.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/11.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCollectionSectionHeader : UICollectionReusableView

+ (CGFloat)height;
- (void)setupWithName:(NSString*)name;

@end
