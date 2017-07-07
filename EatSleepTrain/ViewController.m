//
//  ViewController.m
//  EatSleepTrain
//
//  Created by Jose on 2/26/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     [self.scrollview setContentSize:CGSizeMake(self.view.bounds.size.width*4
                                                ,self.view.bounds.size.height-20)];
     self.scrollview.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipbutton:(id)sender {

}

- (IBAction)page:(id)sender {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView; {
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pagecontrol.currentPage = page;
}

@end
