//
//  NumberSelectView.m
//  昆明团购
//
//  Created by AnYanbo on 15/7/3.
//  Copyright (c) 2015年 NL. All rights reserved.
//

#import "NumberSelectView.h"

@implementation NumberTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

@end

@implementation NumberSelectView

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.numTextField addTarget:self action:@selector(onTextChanged:) forControlEvents:UIControlEventAllEditingEvents];
    
    if (self.maxLength == 0)
    {
        self.maxLength = 5;
    }
    
    self.numTextField.text = @"0";
}

- (void)onTextChanged:(id)sender
{
    NSInteger num = [self.numTextField.text integerValue];
    if ([self.delegate respondsToSelector:@selector(view:didSelectNum:)])
    {
        [self.delegate view:self didSelectNum:num];
    }
}

- (IBAction)onSub:(id)sender
{
    NSString* txt = self.numTextField.text;
    NSInteger num = [txt integerValue] - 1;
    num = num < 0 ? 0 : num;
    
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(view:shouldChangeNum:)])
    {
        should = [self.delegate view:self shouldChangeNum:num];
    }
    if (should == NO)
    {
        return;
    }
    
    self.numTextField.text = [NSString stringWithFormat:@"%ld", (long)num];
    if ([self.delegate respondsToSelector:@selector(view:didSelectNum:)])
    {
        [self.delegate view:self didSelectNum:num];
    }
}

- (IBAction)onAdd:(id)sender
{
    NSString* txt = self.numTextField.text;
    NSInteger max = pow(10, self.maxLength) - 1;
    NSInteger num = [txt integerValue] + 1;
    num = num > max ? max : num;
    
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(view:shouldChangeNum:)])
    {
        should = [self.delegate view:self shouldChangeNum:num];
    }
    if (should == NO)
    {
        return;
    }
    
    self.numTextField.text = [NSString stringWithFormat:@"%ld", (long)num];
    if ([self.delegate respondsToSelector:@selector(view:didSelectNum:)])
    {
        [self.delegate view:self didSelectNum:num];
    }
}

- (NSInteger)number
{
    NSString* num = self.numTextField.text;
    return [num integerValue];
}

- (void)setDefaultNumber:(NSInteger)num
{
    self.numTextField.text = [NSString stringWithFormat:@"%ld", (long)num];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(shoudEditNumView:)])
    {
        should = [self.delegate shoudEditNumView:self];
    }
    return should;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* old = textField.text;
    NSString* now = [old stringByReplacingCharactersInRange:range withString:string];
    if ([now length] > self.maxLength)
    {
        return NO;
    }
    if (now == nil || [now isEqualToString:@""])
    {
        textField.text = @"0";
        
        if ([self.delegate respondsToSelector:@selector(view:didSelectNum:)])
        {
            [self.delegate view:self didSelectNum:0];
        }
        
        return NO;
    }
    if ([now hasPrefix:@"0"] && [now length] >= 2)
    {
        while ([now hasPrefix:@"0"])
        {
            now = [now substringFromIndex:1];
        }
        if (now == nil || [now isEqualToString:@""])
        {
            textField.text = @"0";
            
            if ([self.delegate respondsToSelector:@selector(view:didSelectNum:)])
            {
                [self.delegate view:self didSelectNum:0];
            }
        }
        else
        {
            textField.text = now;
            
            if ([self.delegate respondsToSelector:@selector(view:didSelectNum:)])
            {
                [self.delegate view:self didSelectNum:now.integerValue];
            }
        }
        return NO;
    }
    
    BOOL should = [now isIntValue];
    if (should && [self.delegate respondsToSelector:@selector(view:shouldChangeNum:)])
    {
        should = [self.delegate view:self shouldChangeNum:[now integerValue]];
    }
    return should;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
