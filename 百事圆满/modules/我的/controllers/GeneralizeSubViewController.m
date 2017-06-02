//
//  GeneralizeSubViewController.m
//  百事圆满
//
//  Created by ZhangMeng on 2017/6/2.
//  Copyright © 2017年 Chuangshihuichuang. All rights reserved.
//

#import "GeneralizeSubViewController.h"
#import "GeneralizePeoTableViewCell.h"
#import "GeneralizeOrderTableViewCell.h"

@interface GeneralizeSubViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) GeneralizeViewController *parentVC;
@property (weak, nonatomic) IBOutlet UITableView *questionTableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation GeneralizeSubViewController

- (void)setParent:(GeneralizeViewController*)parent
{
    _parentVC = parent;
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
    self.dataSource=[NSMutableArray array];
    
    [self.questionTableView removeSeperatorBlank];              // 删除 前面的 空白
    [self.questionTableView removeRedundanceSeperator];         // 删除 多余的线
    
    
    [self.questionTableView registerNibName:[GeneralizePeoTableViewCell className] cellID:[GeneralizePeoTableViewCell className]];
    [self.questionTableView registerNibName:[GeneralizeOrderTableViewCell className] cellID:[GeneralizeOrderTableViewCell className]];
    
    [CommonEmptyListView configTableView:self.questionTableView emptyText:@"暂无列表信息~"];
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemTag == 0)
    {
        return [GeneralizePeoTableViewCell height];
    }
    else
    {
        return [GeneralizeOrderTableViewCell height];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.dataSource count])
    {
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.itemTag == 0)
    {
        if (self.dataSource.count != 0)
        {
            return [self.dataSource count];
        }
    }
    else
    {
        if (self.dataSource.count != 0)
        {
            return [self.dataSource count];
        }
    }
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemTag == 0)
    {
        GeneralizePeoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GeneralizePeoTableViewCell className] forIndexPath:indexPath];
        [cell solveCrashWithIOS7];
        [cell removeSeperatorBlank];
        if (indexPath.row < [self.dataSource count])
        {
        }
        return cell;
    }
    else
    {
        GeneralizeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GeneralizeOrderTableViewCell className] forIndexPath:indexPath];
        [cell solveCrashWithIOS7];
        [cell removeSeperatorBlank];
        if (indexPath.row < [self.dataSource count])
        {
        }
        return cell;
    }
    return nil;
}

@end
