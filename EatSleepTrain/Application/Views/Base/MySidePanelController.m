//
//  MySidePanelController.m
//  CustomKeyboardGallery
//
//  Created by Urucode on 7/25/14.
//  Copyright (c) 2014 UruCode. All rights reserved.
//

#import "MySidePanelController.h"

@interface MySidePanelController ()


@end

@implementation MySidePanelController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.leftGapPercentage = 220.0f / 320.0f;
    [super viewDidLoad];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) awakeFromNib {
    
    homeViewController *homeRootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: homeRootViewController];
    [self setCenterPanel:navController];
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftPanelPage"]];
    
}




@end
