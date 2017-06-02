//
//  MainTabBarController.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/6/6.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "MainTabBarController.h"
//#import "MineTableViewController.h"
//#import "LoginTableViewController.h"
#import "NotificationsDefine.h"
#import "UserInfo.h"

@interface MainTabBarController ()
{
}

@end

@implementation MainTabBarController

+ (instancetype)viewController
{
    return [[self class] viewControllerWithStoryboardName:@"Main"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    // 判断APP是否已经使用
    BOOL used = [[NSUserDefaults standardUserDefaults] boolForKey:IS_APP_USED];
    if (used == NO)
    {
#if USE_ANIMATE_FROM_INTRO_TO_MAIN
        self.view.alpha = 0.2f;
        [UIView animateWithDuration:0.1f animations:^{
            self.view.alpha = 1.0f;
        }];
#endif
        // 设置已经使用
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_APP_USED];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout:) name:NOTIFICATION_USER_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popLoginView) name:NOTIFICATION_USER_NEED_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHomeWantBuy:) name:NOTIFICATION_HOME_WANT_BUY_ITEM object:nil];
    
    [self customTabBarItem];
    [self setupTabContoller];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)customTabBarItem
{
    // 添加Tabbar背景
    UIView* back = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    back.backgroundColor = [UIColor whiteColor];
    self.tabBar.opaque = YES;
    [self.tabBar insertSubview:back atIndex:0];
    
    [self setSelectedIndex:0];
    [self.tabBar setSelectedImageTintColor:COMMON_COLOR];
    
    for (int i = 0; i < self.tabBar.items.count; i++)
    {
        UITabBarItem* item = [self.tabBar.items objectAtIndex:i];
        NSString* path = [NSString stringWithFormat:@"TabItem%d_sel", i + 1];
        item.selectedImage = [UIImage imageNamed:path];
    }
}

- (void)setupTabContoller
{
    for (UINavigationController* navController in self.viewControllers)
    {
        NSString* className = [navController restorationIdentifier];
        
        // 首页 | 想去 | 我的
        if (className != nil && [className isEqualToString:@""] == NO)
        {
            Class class = NSClassFromString(className);
            UIViewController* subController = [class viewController];
            if (subController != nil)
            {
                navController.viewControllers = @[subController];
            }
        }
    }
}

- (void)onHomeWantBuy:(NSNotification*)notifi
{
    [self setSelectedIndex:1];
}

//- (void)popLoginView
//{
//    UINavigationController* nav = [LoginTableViewController viewController];
//    [self presentViewController:nav animated:YES completion:^{
//        
//    }];
//}

- (void)onLogout:(NSNotification*)notifi
{
    [self setSelectedIndex:0];
}

#pragma mark - UITabBarControllerDelegate

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewControlle
//{
//    // 未登录状态不能进入我的
//    if ([viewControlle.restorationIdentifier isEqualToString:NSStringFromClass(MineTableViewController.class)])
//    {
//        if ([UserInfo isLogin])
//        {
//            return YES;
//        }
//        else
//        {
//            [self popLoginView];
//            return NO;
//        }
//    }
//    else if ([viewControlle.restorationIdentifier isEqualToString:NSStringFromClass(ShopCartViewController.class)])
//    {
//        if ([UserInfo isLogin])
//        {
//            return YES;
//        }
//        else
//        {
//            [self popLoginView];
//            return NO;
//        }
//    }
//    return YES;
//}

@end
