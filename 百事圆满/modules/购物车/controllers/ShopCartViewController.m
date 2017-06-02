//
//  ShopCartViewController.m
//  百事圆满
//
//  Created by ZhangMeng on 2017/6/1.
//  Copyright © 2017年 Chuangshihuichuang. All rights reserved.
//

#import "ShopCartViewController.h"

@interface ShopCartViewController ()

@end

@implementation ShopCartViewController

+ (instancetype)viewController
{
    ShopCartViewController* ctrl = [[self class] viewControllerWithStoryboardName:@"ShopCart" stroyboardID:[self className]];
    return ctrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
