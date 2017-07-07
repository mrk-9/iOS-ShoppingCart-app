//
//  AppDelegate.h
//  EatSleepTrain
//
//  Created by Jose on 2/26/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, retain) CLLocationManager *locationManager;
@property (strong, retain) CLGeocoder *geocoder;
@property (strong, retain) CLPlacemark *placemark;
@end

