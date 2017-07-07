//
//  WriteReviewViewController.m
//  SCANAPP
//
//  Created by Jose on 4/29/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "WriteReviewViewController.h"
#import "readinfoViewController.h"
@interface WriteReviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *productimgeview;
@property (weak, nonatomic) IBOutlet UILabel *productname;
@property (weak, nonatomic) IBOutlet UITextView *productReview;
@property (assign, nonatomic) BOOL isLoadingView;
@end

@implementation WriteReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rateView.notSelectedImage = [UIImage imageNamed:@"kermit_empty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"kermit_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"kermit_full.png"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    
    
    [commonUtils setRoundedRectBorderImage:_productimgeview withBorderWidth:3 withBorderColor:[UIColor redColor] withBorderRadius:15];
    if(appController.flagQuality){
        
        [commonUtils setImageViewAFNetworking:_productimgeview withImageUrl:appController.scanproductsaveimage[appController.productQualityBtntag] withPlaceholderImage:nil];
        _productname.text=appController.scanproductname[appController.productQualityBtntag];
         appController.flagQuality=NO;
        
    }
    else{
        
        [commonUtils setImageViewAFNetworking:_productimgeview withImageUrl:appController.scanproductsaveimage[appController.indexitem] withPlaceholderImage:nil];
        _productname.text=appController.scanproductname[appController.indexitem];

        
    }
    
}

- (void)viewDidUnload
{
    [self setRateView:nil];
    [self setStatusLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    self.statusLabel.text = [NSString stringWithFormat:@"%.0f", rating];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)reviewSave:(id)sender {
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:[commonUtils getUserDefault:@"user_name"] forKey:@"user_name"];
    [paramDic setObject:_productname.text forKey:@"product_name"];
    [paramDic setObject:_statusLabel.text forKey:@"product_rating"];
    [paramDic setObject:_productReview.text forKey:@"product_review"];
    [self requestAPI:paramDic];
}

#pragma mark - API - productReviewRegister
- (void)requestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData:) toTarget:self withObject:dic];
}

- (void)requestData:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_PRODUCT_REVIEW_REGISTER withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            [self performSelector:@selector(requestOver) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4];
        }
    }
    else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.4];
    }
}


-(void) requestOver {
    
   [self.navigationController popViewControllerAnimated:YES];
    
}



@end
