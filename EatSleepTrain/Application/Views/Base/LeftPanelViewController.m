//
//  LeftPanelViewController.m
//  DomumLink
//
//  Created by AnMac on 1/15/15.
//  Copyright (c) 2015 Petr. All rights reserved.
//

#import "LeftPanelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MySidePanelController.h"
#import "loginViewController.h"
#import "MyAccountViewController.h"
#import "RecentOrderViewController.h"
#import "homeViewController.h"

@interface LeftPanelViewController ()

@property (assign, nonatomic) BOOL isLoadingView;
@end

@implementation LeftPanelViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [commonUtils cropCircleImage:_CurrentUserImageview];
    [commonUtils setCircleBorderImage:_CurrentUserImageview withBorderWidth:3 withBorderColor:RGBA(255, 0, 0, 1)];

    if([appController.menuPhotoTag isEqualToString:@"1"]){
        
        [_CurrentUserImageview setImage:appController.currentUserPhoto];
    }
    else if([[commonUtils getUserDefault:@"menuPhotoTag"] isEqualToString:@"2"]){
        
       NSString *strClientPhoto = [commonUtils getUserDefault:@"user_photo_url"];
       NSString *imageUrl = [NSString stringWithFormat: @"%@%@", MEDIA_URL_USERS, strClientPhoto];
       NSLog(@"%@", imageUrl);
       [commonUtils setImageViewAFNetworking:_CurrentUserImageview  withImageUrl:imageUrl withPlaceholderImage:nil];
        
    }
    else if([[commonUtils getUserDefault:@"menuPhotoTag"] isEqualToString:@"3"]){
         NSString *strClientPhoto = [commonUtils getUserDefault:@"user_photo_url"];
        [commonUtils setImageViewAFNetworking:_CurrentUserImageview  withImageUrl:strClientPhoto withPlaceholderImage:nil];
        
    }
}


- (IBAction)logout:(id)sender {
    //    if(self.isLoadingBase) return;
    //    appController.currentMenuTag = @"1";
   [commonUtils setUserDefault:@"rememberflag" withFormat:@"0"];
    [commonUtils removeUserDefault:@"user_email"];
    [commonUtils removeUserDefault:@"user_password"];
    loginViewController*panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    [self.navigationController pushViewController:panelController animated:YES];
    
}

- (IBAction)myAccount:(id)sender {
    
    MyAccountViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAccountView"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: panelController];
    self.sidePanelController.centerPanel = navController;
}

- (IBAction)recentOrders:(id)sender {
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_name"] forKey:@"user_name"];
    [self FetchOrderInforequestAPI:paramDic];
    
    
}
#pragma mark - API - fetchOrderInfo
- (void)FetchOrderInforequestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData2:) toTarget:self withObject:dic];
}

- (void)requestData2:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_ORDERINFO_FETCH withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.recentorder = [result objectForKey:@"order_info"];
            
           [self performSelector:@selector(requestOver) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
        }
        else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
    
}
-(void) requestOver {

    RecentOrderViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecentOrderView"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: panelController];
    self.sidePanelController.centerPanel = navController;
}
- (IBAction)gohome:(id)sender {
    homeViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: panelController];
    self.sidePanelController.centerPanel = navController;

}

@end

