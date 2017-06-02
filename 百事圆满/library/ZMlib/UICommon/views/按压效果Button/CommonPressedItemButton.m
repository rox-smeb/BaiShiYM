//
//  CommonPressedItemButton.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/6/20.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "CommonPressedItemButton.h"

@interface CommonPressedItemButton ()

@property (nonatomic, strong) UIColor* defaultBKColor;

@end

@implementation CommonPressedItemButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.defaultBKColor = self.backgroundColor;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    if (self.pressedColor == nil)
    {
        self.pressedColor = RGB(220, 220, 220);
    }
    self.backgroundColor = self.pressedColor;
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event
{
    self.backgroundColor = self.defaultBKColor;
    return [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(nullable UIEvent *)event
{
    self.backgroundColor = self.defaultBKColor;
    return [super cancelTrackingWithEvent:event];
}

@end
