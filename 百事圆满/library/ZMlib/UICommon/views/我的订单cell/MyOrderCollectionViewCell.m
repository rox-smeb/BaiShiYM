//
//  MyOrderCollectionViewCell.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/11.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "MyOrderCollectionViewCell.h"

@interface MyOrderCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *countContainer;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation MyOrderCollectionViewCell

+ (CGFloat)height
{
    return 50.0f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.countContainer.layer.cornerRadius = [self.countContainer height] * 0.5f;
}

- (void)setupWithName:(NSString*)name icon:(NSString*)icon count:(NSInteger)count
{
    self.iconImage.image = [UIImage imageNamed:icon];
    self.nameLabel.text = name;
    
    [self updateCount:count];
}

- (void)updateCount:(NSInteger)count
{
    if (count > 1000)
    {
        self.countLabel.text = @"999+";
    }
    else
    {
        self.countLabel.text = [NSString stringWithFormat:@"%d", (int)count];
    }
}

@end
