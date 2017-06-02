//
//  MineTableViewController.m
//  圆满人生
//
//  Created by ZhangMeng on 16/6/6.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "MineTableViewController.h"
#import "MineHeaderView.h"
#import "NotificationsDefine.h"
#import "UserInfo.h"

#import "GeneralizeViewController.h"

#import <AVFoundation/AVFoundation.h>  

#import "TZImagePickerController.h"

#define CAMERA_IMAGE_MAX_SIZE      (400)

@interface MineTableViewController () <UIScrollViewDelegate,
                                       UIActionSheetDelegate,
                                       UIAlertViewDelegate,
                                       UINavigationControllerDelegate,
                                       UIImagePickerControllerDelegate,
                                       MineHeaderViewDelegate,
                                       TZImagePickerControllerDelegate>

@property (strong, nonatomic) MineHeaderView* tableHeader;
@property (strong, nonatomic) UIView* fakeNavBar;                                   // PUSH新页面需要添加一个假的导航栏(当前页面导航栏透明->跳转页面需要保持有导航栏)
@property (weak, nonatomic) IBOutlet UIButton* logoutBtn;

@end

@implementation MineTableViewController

+ (instancetype)viewController
{
    MineTableViewController* ctrl = [[self class] viewControllerWithStoryboardName:@"Mine" stroyboardID:[self className]];
    return ctrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavigationBarAlpha:0.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.fakeNavBar.superview != nil)
    {
        [self.fakeNavBar removeFromSuperview];
    }
    
    [self updateUI];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self setNavigationBarAlpha:1.0f];
    [self.fakeNavBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setup
{
    [self.tableView solveCrashWithIOS7];
    [self.tableView removeSeperatorBlank];
    
    
    self.logoutBtn.layer.cornerRadius = 4.0f;
    self.logoutBtn.layer.masksToBounds = YES;
    self.logoutBtn.layer.borderColor = RGB(232, 63, 65).CGColor;
    self.logoutBtn.layer.borderWidth = 1.0f;
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.delegate = self;
    [self setNavigationBarAlpha:0.0f];
    
    // 创建头像表头
    self.tableHeader = [MineHeaderView create];
    self.tableHeader.delegate = self;
    [self.tableHeader expandWithScrollView:self.tableView];
}

- (void)updateUI
{
    UserInfo* info = [UserInfo currentUser];
    if (info != nil)
    {
        NSString* nick = @"";
        if ([info.Name isAvailability])
        {
            nick = info.Name;
        }
        else
        {
            nick = [info.Mobile encryptMobileWithString:@"*"];
        }
        [self.tableHeader updateWithHeadURL:info.url name:nick];
    }
}

- (IBAction)onLogoutTouch:(UIButton *)sender
{
    LXAlertView* alert = [[LXAlertView alloc] initWithTitle:@"提示" message:@"确认注销当前登录账号?" cancelBtnTitle:@"取消" otherBtnTitle:@"确认" clickIndexBlock:^(NSInteger clickIndex) {
        
        if (clickIndex == 1)
        {
//            // 用户登出
//            [UserInfo logout];
//            
//            // 发送登出消息
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGOUT object:nil];
        }
    }];
    [alert showLXAlertView];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self)
    {
        if (navigationController.viewControllers.count == 2)
        {
            if (self.fakeNavBar == nil)
            {
                CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
                CGFloat width = [self.navigationController.navigationBar width];
                CGFloat height = statusHeight + [self.navigationController.navigationBar height];
                self.fakeNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, -height, width, height)];
                self.fakeNavBar.backgroundColor = COMMON_COLOR;
            }
            
            if (self.fakeNavBar.superview != nil)
            {
                [self.fakeNavBar removeFromSuperview];
            }
            
            [viewController.view addSubview:self.fakeNavBar];
        }
    }
    else
    {
        if (self.fakeNavBar != nil)
        {
            [self.fakeNavBar setHidden:NO];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self)
    {
        if (navigationController.viewControllers.count == 2)
        {
            [self.fakeNavBar setHidden:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableHeader scrollViewDidScroll:scrollView];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
        
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.restorationIdentifier isEqualToString:@"个人信息"])                       // 我的信息
    {

    }
    else if ([cell.restorationIdentifier isEqualToString:@"订单信息"])                  // 订单信息
    {

    }
    else if ([cell.restorationIdentifier isEqualToString:@"推广信息"])                  // 推广信息
    {
        GeneralizeViewController *vc = [GeneralizeViewController viewController];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([cell.restorationIdentifier isEqualToString:@"我的收藏"])                  // 我的收藏
    {
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [super tableView:tableView numberOfRowsInSection:section];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell solveCrashWithIOS7];
    [cell removeSeperatorBlank];
    return cell;
}

@end
