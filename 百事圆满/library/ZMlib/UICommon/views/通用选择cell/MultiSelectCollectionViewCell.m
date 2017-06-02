//
//  MultiSelectCollectionViewCell.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/9.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "MultiSelectCollectionViewCell.h"

@interface MultiSelectCollectionViewCell ()

@property (strong, nonatomic) NSIndexPath* indexPath;
@property (weak, nonatomic) IBOutlet UIView *nameLabelContainer;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation MultiSelectCollectionViewCell

+ (CGFloat)height
{
    return 60.0f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.nameLabelContainer.layer.cornerRadius = 4.0f;
}

- (void)setupWithName:(NSString*)name indexPath:(NSIndexPath*)indexPath
{
    self.nameLabel.text = name;
    self.indexPath = indexPath;
}

- (IBAction)onClose:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(multiSelectCollectionViewCell:didCloseAtIndexPath:withName:)])
    {
        [self.delegate multiSelectCollectionViewCell:self didCloseAtIndexPath:self.indexPath withName:self.nameLabel.text];
    }
}

@end
