//
//  WFBaseViewController.m
//  Woof
//
//  Created by Mac on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import "BaseViewController.h"
#import "shoppingcartViewController.h"
#import "scanViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if([commonUtils isUserLoggedIn] == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.isLoadingBase = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be ecreated.
}

- (BOOL) prefersStatusBarHidden {
    return NO;
}

# pragma Top Menu Events
- (IBAction)menuClicked:(id)sender {
//    if(self.isLoadingBase) return;
    [self.sidePanelController showLeftPanelAnimated: YES];
}
- (IBAction)menuBackClicked:(id)sender {
    if(self.isLoadingBase) return;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)navToMainView:(id)sender {
//    if(self.isLoadingBase) return;
    //    appController.currentMenuTag = @"1";
    homeViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
    [self.navigationController pushViewController:panelController animated:YES];
    
}
-(IBAction)goShoppingCart:(id)sender{
    shoppingcartViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"shoppingcartView"];
    [self.navigationController pushViewController:panelController animated:YES];
}

-(IBAction)goBarcodeScan:(id)sender{
    
    scanViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"scanView"];
    [self.navigationController pushViewController:panelController animated:YES];
}
@end
