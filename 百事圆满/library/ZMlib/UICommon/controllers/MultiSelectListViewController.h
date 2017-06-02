//
//  MultiSelectListViewController.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/8.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectModelProtocol.h"

@class MultiSelectListViewController;

@protocol MultiSelectListViewControllerDelegate <NSObject>

- (void)multiSelectListViewController:(MultiSelectListViewController*)ctrl
                   didSelectInfoArray:(NSArray<id<SelectModelProtocol>>*)infoArray;

- (BOOL)multiSelectListViewController:(MultiSelectListViewController*)ctrl
                    isSelectedForInfo:(id<SelectModelProtocol>)info;

@end

/**
 *  多选列表
 */
@interface MultiSelectListViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;

+ (UINavigationController*)navViewControllerWithTitle:(NSString*)title
                                           dataSource:(NSArray<id<SelectModelProtocol>>*)dataSource
                                             delegate:(id<MultiSelectListViewControllerDelegate>)delegate;

+ (UINavigationController*)navViewControllerWithTitle:(NSString*)title
                                           dataSource:(NSArray<id<SelectModelProtocol>>*)dataSource
                                             delegate:(id<MultiSelectListViewControllerDelegate>)delegate
                                                  tag:(NSInteger)tag;

@end
