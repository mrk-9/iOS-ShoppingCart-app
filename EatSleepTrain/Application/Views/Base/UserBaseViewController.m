//
//  GigUserBaseViewController.m
//  Gigzila
//
//  Created by Mac on 1/9/15.
//  Copyright (c) 2015 newmobileStar. All rights reserved.
//

#import "UserBaseViewController.h"


@interface UserBaseViewController ()

@end

@implementation UserBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

   
    self.isLoadingUserBase = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden {
    
    return YES;
}

#pragma mark - Nagivate Events
- (void) navToMainView {
    if(self.isLoadingUserBase) return;
//    appController.currentMenuTag = @"1";
    MySidePanelController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"MysidePanel"];
    [self.navigationController pushViewController:panelController animated:YES];
}
- (IBAction)menuBackClicked:(id)sender {
    if(self.isLoadingUserBase) return;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
