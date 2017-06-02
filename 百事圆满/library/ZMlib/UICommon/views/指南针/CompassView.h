//
//  CompassView.h
//  美游时代
//
//  Created by AnYanbo on 16/5/27.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompassView : UIView

+ (BOOL)allowCompass;

- (BOOL)startCompass;
- (void)stopCompass;

@end
