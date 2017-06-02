//
//  MultiSelectCollectionViewCell.h
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/9.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiSelectCollectionViewCell;

@protocol MultiSelectCollectionViewCellDelegate <NSObject>

- (void)multiSelectCollectionViewCell:(MultiSelectCollectionViewCell*)cell didCloseAtIndexPath:(NSIndexPath*)indexPath withName:(NSString*)name;

@end

@interface MultiSelectCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<MultiSelectCollectionViewCellDelegate> delegate;

+ (CGFloat)height;
- (void)setupWithName:(NSString*)name indexPath:(NSIndexPath*)indexPath;

@end
