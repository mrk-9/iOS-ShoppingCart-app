//
//  ViewController.h
//  EatSleepTrain
//
//  Created by Jose on 2/26/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate>

- (IBAction)skipbutton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bg1;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UIView *bg2;
@property (weak, nonatomic) IBOutlet UIView *bg3;
@property (weak, nonatomic) IBOutlet UIView *bg4;
- (IBAction)page:(id)sender;

@end

