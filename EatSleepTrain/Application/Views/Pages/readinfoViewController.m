//
//  readinfoViewController.m
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "readinfoViewController.h"
#import "ReviewViewController.h"
#import "shoppingcartViewController.h"
@interface readinfoViewController (){
    NSInteger item;
    NSString *totalitem;
    double price,sumprice;
    
  
}
@property (weak, nonatomic) IBOutlet UIImageView *productimgeview;
@property (weak, nonatomic) IBOutlet UILabel *productname;
@property (weak, nonatomic) IBOutlet UILabel *productprice;
@property (weak, nonatomic) IBOutlet UITextView *productdescription;
@property (assign, nonatomic) BOOL isLoadingView;

@end

@implementation readinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    item=1;
    totalitem = [NSString stringWithFormat:@"%li",(long)item];
    
    [commonUtils setRoundedRectBorderImage:_productimgeview withBorderWidth:3 withBorderColor:[UIColor redColor] withBorderRadius:15];
    
    if(appController.flagQuality){
        
        [commonUtils setImageViewAFNetworking:_productimgeview withImageUrl:appController.scanproductsaveimage[appController.productQualityBtntag] withPlaceholderImage:nil];
         _productname.text=appController.scanproductname[appController.productQualityBtntag];
        _productprice.text=appController.scanproductprice[appController.productQualityBtntag];
        _productdescription.text=appController.scanproductdescription[appController.productQualityBtntag];
        price= [_productprice.text doubleValue];
        
    }
    else{
        [commonUtils setImageViewAFNetworking:_productimgeview withImageUrl:appController.scanproductsaveimage[appController.indexitem] withPlaceholderImage:nil];
        
        _productname.text=appController.scanproductname[appController.indexitem];
        _productprice.text=appController.scanproductprice[appController.indexitem];
        _productdescription.text=appController.scanproductdescription[appController.indexitem];
        price= [_productprice.text doubleValue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ProductReviews:(id)sender {
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject: _productname.text forKey:@"product_name"];
    [self FetchProductReviewsrequestAPI:paramDic];
    
    
}
#pragma mark - API -FetchProductReviewsrequestAPI
- (void)FetchProductReviewsrequestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData1:) toTarget:self withObject:dic];
}

- (void)requestData1:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_PRODUCT_REVIEWS_FETCH withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.productreviwes = [result objectForKey:@"productreviews"];
            
            NSLog(@" result is %@", appController.productreviwes);
            
            [self performSelector:@selector(requestOver1) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
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
-(void) requestOver1 {
    
    ReviewViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewView"];
    [self.navigationController pushViewController:panelController animated:YES];
   
}

- (IBAction)addtoCart:(id)sender {
    
    
    [appController.productnameArray addObject:_productname.text];
    [appController.productpriceArray addObject:_productprice.text];
    if(appController.flagQuality)
    {
       [appController.productimageArray addObject:appController.scanproductsaveimage[appController.productQualityBtntag]];
        appController.producttotalprice=appController.producttotalprice+price;

        appController.flagQuality=NO;
    }
    else{
        [appController.productimageArray addObject:appController.scanproductsaveimage[appController.indexitem]];
         appController.producttotalprice=appController.producttotalprice;

    }

    [appController.productquantity addObject:totalitem];
     

    shoppingcartViewController *productnameview = [self.storyboard instantiateViewControllerWithIdentifier:@"shoppingcartView"];
    [self.navigationController pushViewController:productnameview animated:YES];
    

}



@end
