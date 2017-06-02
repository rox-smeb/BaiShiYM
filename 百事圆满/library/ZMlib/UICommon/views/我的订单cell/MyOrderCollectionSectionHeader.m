//
//  MyOrderCollectionSectionHeader.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/11.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "MyOrderCollectionSectionHeader.h"

@interface MyOrderCollectionSectionHeader ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MyOrderCollectionSectionHeader

+ (CGFloat)height
{
    return 40.0f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setupWithName:(NSString*)name
{
    self.nameLabel.text = name;
}

@end
