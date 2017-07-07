//
//  WFBaseViewController.h
//  Woof
//
//  Created by Mac on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL isLoadingBase;

- (IBAction)menuClicked:(id)sender;
- (IBAction)menuBackClicked:(id)sender;
- (IBAction)navToMainView:(id)sender;
-(IBAction)goShoppingCart:(id)sender;
-(IBAction)goBarcodeScan:(id)sender;
@end
