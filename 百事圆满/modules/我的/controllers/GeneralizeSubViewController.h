//
//  GeneralizeSubViewController.h
//  百事圆满
//
//  Created by ZhangMeng on 2017/6/2.
//  Copyright © 2017年 Chuangshihuichuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralizeViewController.h"

@interface GeneralizeSubViewController : UIViewController

@property (nonatomic, assign) NSInteger itemTag;

- (void)setParent:(GeneralizeViewController*)parent;

@end
