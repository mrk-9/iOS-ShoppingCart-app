//
//  AppDelegate.m
//  EatSleepTrain
//
//  Created by Jose on 2/26/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "homeViewController.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
   sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if([[commonUtils getUserDefault:@"rememberflag"] isEqualToString:@"1"]){
        
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        MySidePanelController *controller = (MySidePanelController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MysidePanel"];
        [navigationController pushViewController:controller animated:YES];
        
        
    }
   
//    Paypal SDK initialize and provide client's IDs
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"Ab9XKCVAztBoR9Mg37qC6WFoB2DJu47n2qznlvcrTIbawD5_jQv-7DQd4mofL9PEfEw18NPXrauoriI1",
                                                           PayPalEnvironmentSandbox : @"AQriZGKSAsoia1_cRiEX5L0gtctcDAwLWAGfszzrcvaxdmy2jCcBtc_iLk6f1Eecsm3Cw6Yz1F64_CEl"}];
    

    //change status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
   ///device loction allow
    [self updateLocationManager];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    if(launchOptions != nil && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        appController.apnsMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"info"];
        [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"1"];
    }

    
    
    return YES;
}
- (void)updateLocationManager {
    //    if([commonUtils getUserDefault:@"flag_location_query_enabled"] != nil && [[commonUtils getUserDefault:@"flag_location_query_enabled"] isEqualToString:@"1"]) {
    _locationManager = [[CLLocationManager alloc] init];
    _geocoder=[[CLGeocoder alloc] init];
    _locationManager.delegate = self;
    [_locationManager setDistanceFilter:804.17f]; // Distance Filter as 0.5 mile (1 mile = 1609.34m)
    //locationManager.distanceFilter=kCLDistanceFilterNone;
    
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    //    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    //        [_locationManager requestWhenInUseAuthorization];
    //    }
    
    if(IS_OS_8_OR_LATER) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    //    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [commonUtils setUserDefault:@"user_apns_id" withFormat:newToken];
    NSLog(@"My saved token is: %@", [commonUtils getUserDefault:@"user_apns_id"]);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    if ([commonUtils getUserDefault:@"push_notification_enable" ] != nil && [[commonUtils getUserDefault:@"push_notification_enable" ] isEqualToString:@"YES"]){
        
        appController.apnsMessage = [[NSMutableDictionary alloc] init];
        appController.apnsMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"info"];
        
        NSLog(@"APNS Info Fetched : %@", userInfo);
        NSLog(@"My Received Message : %@", appController.apnsMessage);
        
        [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"1"];
        
        //    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        //    UINavigationController *navController = (UINavigationController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"rootNav"];
        //
        //    if([commonUtils getUserDefault:@"current_user_user_id"] != nil) {
        //        navController.navigationBarHidden = NO;
        //    } else {
        //        navController.navigationBarHidden = YES;
        //    }
        //    self.window.rootViewController = navController;
        
        [application setApplicationIconBadgeNumber:[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue]];
    }
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    //[commonUtils showAlert:@"Error" withMessage:@"Failed to Get Your Location"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        BOOL locationChanged = NO;
        if(![commonUtils getUserDefault:@"currentLatitude"] || ![commonUtils getUserDefault:@"currentLongitude"]) {
            locationChanged = YES;
        } else if(![[commonUtils getUserDefault:@"currentLatitude"] isEqualToString:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]] || ![[commonUtils getUserDefault:@"currentLongitude"] isEqualToString:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]]) {
            locationChanged = YES;
        }
        if(locationChanged) {
            [commonUtils setUserDefault:@"currentLatitude" withFormat:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]];
            [commonUtils setUserDefault:@"currentLongitude" withFormat:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]];
            //[commonUtils setUserDefault:@"barksUpdate" withFormat:@"1"];
            [self updateUserLocation];
        }
    }
    
    NSLog(@"Resolving the Address");
    [_geocoder reverseGeocodeLocation:currentLocation completionHandler:^(
                                                                          NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            _placemark = [placemarks lastObject];
           [commonUtils setUserDefault:@"currentuserlocation" withFormat:[NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 _placemark.subThoroughfare, _placemark.thoroughfare,
                                 _placemark.postalCode, _placemark.locality,
                                 _placemark.administrativeArea,
                                 _placemark.country]];
            
            NSLog(@"%@",[NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                         _placemark.subThoroughfare, _placemark.thoroughfare,
                         _placemark.postalCode, _placemark.locality,
                         _placemark.administrativeArea,
                         _placemark.country]);
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    //[locationManager stopUpdatingLocation];
    //[self updateUserLocation];
}

- (void)updateUserLocation {  //for update user's coordinate automatically
    NSString *msg = [NSString stringWithFormat:@"%@:%@", [commonUtils getUserDefault:@"currentLatitude"], [commonUtils getUserDefault:@"currentLongitude"]];
    [commonUtils showAlert:@"Location Updated" withMessage:msg];
}


@end
