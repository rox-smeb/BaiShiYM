//
//  CompassView.m
//  美游时代
//
//  Created by AnYanbo on 16/5/27.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "CompassView.h"

#import <CoreLocation/CoreLocation.h>

@interface CompassView () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (weak, nonatomic) IBOutlet UIImageView* compassBK;
@property (weak, nonatomic) IBOutlet UIImageView* compassPoint;
@property (weak, nonatomic) IBOutlet UILabel* title;

@end

@implementation CompassView

+ (BOOL)allowCompass
{
    return [CLLocationManager headingAvailable];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setup];
}

- (void)setup
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)dealloc
{
    [self stopCompass];
}

- (BOOL)startCompass
{
    if ([[self class] allowCompass])
    {
        [self.locationManager startUpdatingHeading];
        
        return YES;
    }
    return NO;
}

- (void)stopCompass
{
    [self.locationManager startUpdatingHeading];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager error: %@", [error description]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    CGFloat heading = -1.0f * M_PI * newHeading.magneticHeading / 180.0f;
    self.title.text = [NSString stringWithFormat:@"%d°", (int)newHeading.magneticHeading];
    self.compassPoint.transform = CGAffineTransformMakeRotation(heading);
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

@end
