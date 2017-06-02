//
//  NumberSelectView.h
//  昆明团购
//
//  Created by AnYanbo on 15/7/3.
//  Copyright (c) 2015年 NL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumberSelectView;

@protocol NumberSelectViewDelegate <NSObject>

@optional

- (BOOL)shoudEditNumView:(NumberSelectView*)view;
- (BOOL)view:(NumberSelectView*)view shouldChangeNum:(NSInteger)num;
- (void)view:(NumberSelectView*)view didSelectNum:(NSInteger)num;

@end

@interface NumberTextField : UITextField

@end

@interface NumberSelectView : UIView <UITextFieldDelegate>
{
    
}

@property (assign, nonatomic) NSInteger maxLength;
@property (weak, nonatomic) id<NumberSelectViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *subButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet NumberTextField *numTextField;

- (NSInteger)number;
- (void)setDefaultNumber:(NSInteger)num;

@end
