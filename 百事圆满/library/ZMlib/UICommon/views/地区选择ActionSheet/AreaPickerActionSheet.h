//
//  AreaPickerActionSheet.h
//  昆明团购
//
//  Created by AnYanbo on 15/6/27.
//  Copyright (c) 2015年 NL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AreaPickerActionSheet;

@protocol AreaPickerActionSheetDelegate <NSObject>

- (void)actionSheet:(AreaPickerActionSheet*)sheet didSelectedLocation:(HZLocation*)location;

@end

@interface AreaPickerActionSheet : NSObject
{
    
}

@property (nonatomic, weak) id<AreaPickerActionSheetDelegate> delegate;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* confrimButtonTitle;
@property (nonatomic, strong) NSString* cancleButtonTitle;

+ (instancetype)create;
- (void)showInView:(UIView*)view;
- (void)showInView:(UIView*)view height:(CGFloat)height;
- (void)selectProvince:(NSString*)p city:(NSString*)c zone:(NSString*)z;

@end
