//
//  GigUserBaseViewController.h
//  Gigzila
//
//  Created by Mac on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserBaseViewController : UIViewController

@property (nonatomic, assign) BOOL isLoadingUserBase;

- (void)navToMainView;
- (IBAction)menuBackClicked:(id)sender;

@end
