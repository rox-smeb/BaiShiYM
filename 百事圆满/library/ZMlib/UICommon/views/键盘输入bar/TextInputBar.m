//
//  TextInputBar.m
//  美游时代
//
//  Created by AnYanbo on 16/5/6.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "TextInputBar.h"

@interface TextInputBar () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView* inputContainer;
@property (weak, nonatomic) IBOutlet UITextField* inputTextField;
@property (weak, nonatomic) IBOutlet UIButton* publishBtn;

@end

@implementation TextInputBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.inputContainer.layer.masksToBounds = YES;
    self.inputContainer.layer.cornerRadius = 5.0f;
}

- (void)clearText
{
    self.inputTextField.text = @"";
}

- (void)becomeFirstResponder
{
    [self.inputTextField becomeFirstResponder];
}

- (void)resignFirstResponder
{
    [super resignFirstResponder];
    [self.inputTextField resignFirstResponder];
}

- (IBAction)onPublishTouch:(UIButton *)sender
{
    NSString* text = self.inputTextField.text;
    
    if ([self.delegate respondsToSelector:@selector(inputBar:publishWithText:)])
    {
        [self.delegate inputBar:self publishWithText:text];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
