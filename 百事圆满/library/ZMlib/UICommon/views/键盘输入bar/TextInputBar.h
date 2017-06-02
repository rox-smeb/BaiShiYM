//
//  TextInputBar.h
//  美游时代
//
//  Created by AnYanbo on 16/5/6.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextInputBar;

@protocol TextInputBarDelegate <NSObject>

@optional

- (void)inputBar:(TextInputBar*)inputBar publishWithText:(NSString*)text;

@end

@interface TextInputBar : UIView

@property (nonatomic, weak) id<TextInputBarDelegate> delegate;

- (void)clearText;
- (void)becomeFirstResponder;
- (void)resignFirstResponder;

@end
