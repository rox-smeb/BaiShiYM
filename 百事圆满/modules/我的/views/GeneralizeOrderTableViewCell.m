//
//  GeneralizeOrderTableViewCell.m
//  百事圆满
//
//  Created by ZhangMeng on 2017/6/2.
//  Copyright © 2017年 Chuangshihuichuang. All rights reserved.
//

#import "GeneralizeOrderTableViewCell.h"

#define IMAGE_WIDTH                         (75.0f)
#define IMAGE_WIDTH_INTERVAL                (8.0f)

@interface GeneralizeOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollWidth;
@property (weak, nonatomic) IBOutlet UIView *scrollView;

@end

@implementation GeneralizeOrderTableViewCell

+ (CGFloat)height
{
    return 160.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setup
{
    int index = 5;
    self.scrollWidth.constant = index * (IMAGE_WIDTH + IMAGE_WIDTH_INTERVAL) - IMAGE_WIDTH_INTERVAL;
    
    for (int i = 0; i < index; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(IMAGE_WIDTH+IMAGE_WIDTH_INTERVAL), 0, IMAGE_WIDTH, IMAGE_WIDTH)];
        imageView.image = [UIImage imageNamed:@"默认头像1"];
        [self.scrollView addSubview:imageView];
    }
}

@end
