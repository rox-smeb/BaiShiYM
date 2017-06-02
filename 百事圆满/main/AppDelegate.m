//
//  AppDelegate.m
//  百事圆满
//
//  Created by ZhangMeng on 2017/5/31.
//  Copyright © 2017年 Chuangshihuichuang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "UserInfo.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // DEBUG打印app信息
    [self appInfo];
    
    // 配置Bugly
    //[self configBugly];
    
    // 配置数据管理器
    //    [self configDataManager];
    
    // 配置刷新控件
    [self configRefresh];
    
    // 配置导航栏
    [self configNav];
    
    //    // 配置高德API
    //    [self configAMap];
    //
    //    // 配置讯飞
    //    [self configIFlySpeech];
    
    // 配置网络缓存
    [self configNetEngine];
    
    // 初始化程序入口
    [self configRootViewController];
    
    return YES;

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}

#pragma mark - Custom

// 打印基本信息
- (void)appInfo
{
#ifdef DEBUG
    NSLog(@"AppVersion:%@", [YBUtility appVersion]);
    NSLog(@"AppBuildVersion:%@", [YBUtility appBuildVersion]);
    NSLog(@"SystemVersion:%@", [YBUtility systemVersion]);
    NSLog(@"HomeDirectory:%@", NSHomeDirectory());
//    NSLog(@"YBCommonKit VersionNumber:%lf Version:%s", YBCommonKitVersionNumber, YBCommonKitVersionString);
#endif
}

// 开启网络缓存
- (void)configNetEngine
{
    [YBNetworkEngine setupSharedInstanceWithHost:URL_BASE portNum:URL_PORT_NUM];
    [[YBNetworkEngine sharedInstance] useCache];
}

//- (void)configAMap
//{
//    [AMapLocationServices sharedServices].apiKey = AMAP_APP_KEY;
//    [AMapNaviServices sharedServices].apiKey     = AMAP_APP_KEY;
//    [MAMapServices sharedServices].apiKey        = AMAP_APP_KEY;
//}
//
//- (void)configIFlySpeech
//{
//    [IFlySetting setLogFile:LVL_NONE];
//    [IFlySetting showLogcat:NO];
//
//    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", IFLY_APP_KEY];
//    [IFlySpeechUtility createUtility:initString];
//
//    // 设置语音合成的参数
//    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];      //合成的语速,取值范围 0~100
//    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];     //合成的音量;取值范围 0~100
//
//    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
//    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
//
//    // 音频采样率,目前支持的采样率有 16000 和 8000;
//    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
//
//    // 当你再不需要保存音频时，请在必要的地方加上这行。
//    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
//}

// 配置刷新控件
- (void)configRefresh
{
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray* images = [NSMutableArray array];
    UIImage* image = [UIImage imageNamed:@"start_v2"];
    if (image != nil)
    {
        [images addObject:image];
    }
    [UIScrollView setPullingImages:images];
    
    // 设置空闲状态的动画图片
    images = [NSMutableArray array];
    image = [UIImage imageNamed:@"finish_v2"];
    if (image != nil)
    {
        [images addObject:image];
    }
    [UIScrollView setIdleImages:images];
    
    // 设置正在刷新状态的动画图片
    images = [NSMutableArray array];
    for (int i = 0; i < 7; i++)
    {
        NSString* name = [NSString stringWithFormat:@"Refresh%03d", i];
        UIImage* image = [UIImage imageNamed:name];
        if (image != nil)
        {
            [images addObject:image];
        }
    }
    [UIScrollView setRefreshingImages:images];
}

// 配置导航栏
- (void)configNav
{
    UIColor* color   = [UIColor whiteColor];
    UIFont* font     = [UIFont systemFontOfSize:NAV_TITLE_FONT_SIZE];
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor clearColor]];
    
    // 设置导航栏标题
    NSMutableDictionary* attr = [NSMutableDictionary dictionary];
    [attr addParam:shadow forKey:NSShadowAttributeName];
    [attr addParam:color forKey:NSForegroundColorAttributeName];
    [attr addParam:font forKey:NSFontAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:attr];
    
    if (AboveIOS7)
    {
        [[UINavigationBar appearance] setBarTintColor:COMMON_COLOR];
    }
    [YBUtility setNavBackButtonImage:@"返回" andSelectedImage:@"返回"];
    
    if ([YBUtility systemVersionFloat] >= 6.0f)
    {
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
}

// 配置入口点
- (void)configRootViewController
{
    // 设置了storyboard中的 Main Interface
    if (self.window != nil)
    {
        return;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BOOL used = [[NSUserDefaults standardUserDefaults] boolForKey:IS_APP_USED];
    used = YES;
    if (used == NO)
    {
        
    }
    else
    {
        MainTabBarController* ctrl = [MainTabBarController viewController];
        self.window.rootViewController = ctrl;
    }
    [self.window makeKeyAndVisible];
}

@end
