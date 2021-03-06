//
//  HomeTableViewController.m
//  百事圆满
//
//  Created by ZhangMeng on 2017/5/31.
//  Copyright © 2017年 Chuangshihuichuang. All rights reserved.
//

#import "HomeTableViewController.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

+ (instancetype)viewController
{
    HomeTableViewController* ctrl = [[self class] viewControllerWithStoryboardName:@"Home" stroyboardID:[self className]];
    return ctrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setup
{
    [self.tableView solveCrashWithIOS7];
    [self.tableView removeSeperatorBlank];

    [CommonEmptyListView configTableView:self.tableView emptyText:@"小伙伴们正在努力开发中~"];
}

@end
