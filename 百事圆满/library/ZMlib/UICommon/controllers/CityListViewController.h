//
//  CityListViewController.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/6/22.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

// NSNotification.object => CityInfo*
#define NOTIFICIATION_CITY_LIST_CONTROLLER_DID_SELECTED_CITY_INFO               (@"NOTIFICIATION_CITY_LIST_CONTROLLER_DID_SELECTED_CITY_INFO")

@class CityListViewController;

/********************************** CityInfo **********************************/
@interface CityInfo : NSObject

@property (nonatomic, strong) NSString* CityId;
@property (nonatomic, strong) NSString* ProvincialId;
@property (nonatomic, strong) NSString* Name;
@property (nonatomic, strong) NSString* PinYin;                 // Name拼音
@property (nonatomic, strong) NSString* Letter;                 // Name拼音首字母
@property (nonatomic, strong) NSString* Code;
@property (nonatomic, strong) NSString* Sort;

@end

/************************ CityListViewControllerDelegate ***********************/
@protocol CityListViewControllerDelegate <NSObject>

@optional

- (BOOL)cityListController:(CityListViewController*)controller shouldDismissWhenSelecteCityInfo:(CityInfo*)cityInfo;
- (void)cityListController:(CityListViewController*)controller didSelectedCityInfo:(CityInfo*)cityInfo;

@end

/**************************** CityListTableViewCell ****************************/
@interface CityListTableViewCell : UITableViewCell

+ (CGFloat)height;

@end

/*************************** CityListViewController ****************************/
@interface CityListViewController : UIViewController

@property (nonatomic, weak) id<CityListViewControllerDelegate> delegate;

+ (UIViewController*)viewControllerWithDelegete:(id<CityListViewControllerDelegate>)delegate;
+ (UIViewController*)viewControllerWithInfos:(NSArray<CityInfo*>*)infos;
+ (UIViewController*)viewControllerWithInfos:(NSArray<CityInfo*>*)infos
                                    delegete:(id<CityListViewControllerDelegate>)delegate;

@end
