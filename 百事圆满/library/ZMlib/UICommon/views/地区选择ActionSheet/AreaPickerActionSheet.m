//
//  AreaPickerActionSheet.m
//  昆明团购
//
//  Created by AnYanbo on 15/6/27.
//  Copyright (c) 2015年 NL. All rights reserved.
//

#import "AreaPickerActionSheet.h"

@interface AreaPickerActionSheet () <HZAreaPickerDatasource, HZAreaPickerDelegate>
{
    HZLocation* _locate;
}

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) HZAreaPickerView* locatePicker;
@property (strong, nonatomic) NSMutableArray* locateData;

@end

@implementation AreaPickerActionSheet

+ (instancetype)create
{
    AreaPickerActionSheet* sheet = [[AreaPickerActionSheet alloc] init];
    return sheet;
}

- (void)showInView:(UIView*)view
{
    [self showInView:view height:200.0f];
}

- (void)showInView:(UIView*)view height:(CGFloat)height
{
    CGFloat titleHeight = 15.0f;
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, height)];

    // 标题label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:self.titleLabel];
    
    [[self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading] autoInstall];
    [[self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing] autoInstall];
    [[self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop] autoInstall];
    [self.titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:contentView withOffset:titleHeight];
    
    // 城市选择Picker
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict
                                                   withDelegate:self
                                                  andDatasource:self];
    [self.locatePicker selectDefault];
    
    [contentView addSubview:self.locatePicker];
    [[self.locatePicker autoPinEdgeToSuperviewEdge:ALEdgeLeading] autoInstall];
    [[self.locatePicker autoPinEdgeToSuperviewEdge:ALEdgeTrailing] autoInstall];
    [[self.locatePicker autoPinEdgeToSuperviewEdge:ALEdgeBottom] autoInstall];
    [[self.locatePicker autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:titleHeight] autoInstall];
    
    if (self.title == nil)
    {
        self.title = @"请选择省市区";
    }
    
    if (self.confrimButtonTitle == nil)
    {
        self.confrimButtonTitle = @"确 认";
    }
    if (self.cancleButtonTitle == nil)
    {
        self.cancleButtonTitle = @"取 消";
    }
    
    JGActionSheetSection* s1 = [JGActionSheetSection sectionWithTitle:self.title
                                                              message:nil
                                                          contentView:contentView];
    JGActionSheetSection* s2 = [JGActionSheetSection sectionWithTitle:nil
                                                              message:nil
                                                         buttonTitles:@[self.confrimButtonTitle, self.cancleButtonTitle]
                                                          buttonStyle:JGActionSheetButtonStyleDefault];
    
    [s2 setButtonTitleColor:[UIColor whiteColor]
                       font:[UIFont systemFontOfSize:15.0f]
            backgroundColor:COMMON_COLOR
                borderColor:COMMON_COLOR atIndex:0];
    
    [s2 setButtonTitleColor:UIColorMake(120, 120, 120)
                       font:[UIFont systemFontOfSize:15.0f]
            backgroundColor:UIColorMake(239, 239, 239)
                borderColor:UIColorMake(223, 223, 223)
                    atIndex:1];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[s1, s2]];
    [sheet showInView:view animated:YES];
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        
        if (indexPath.row == 0)
        {
            if ([self.delegate respondsToSelector:@selector(actionSheet:didSelectedLocation:)])
            {
                if (_locate == nil)
                {
                    _locate = self.locatePicker.locate;
                }
                [self.delegate actionSheet:self didSelectedLocation:_locate];
            }
        }
        [sheet dismissAnimated:YES];
    }];
    
    [sheet setOutsidePressBlock:^(JGActionSheet* sheet) {
        [sheet dismissAnimated:YES];
    }];
}

- (void)selectProvince:(NSString*)p city:(NSString*)c zone:(NSString*)z
{
    [self.locatePicker selectProvince:p city:c zone:z];
}

#pragma mark - JGActionSheetDelegate

- (void)actionSheetDidDismiss:(JGActionSheet *)actionSheet
{
}

#pragma mark - HZAreaPickerDelegate

- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    _locate = picker.locate;
    self.titleLabel.text = [picker.locate locationString];
}

#pragma mark - HZAreaPickerDatasource

- (NSArray*)areaPickerData:(HZAreaPickerView *)picker
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    if (self.locateData == nil)
    {
        self.locateData = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    return self.locateData;
}

@end
