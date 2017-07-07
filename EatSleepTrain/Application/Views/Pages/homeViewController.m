//
//  homeViewController.m
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "homeViewController.h"
#import "FeaturedViewController.h"
#import "NewViewController.h"
#import "CategorylistViewController.h"
#import "BrandlistViewController.h"

@interface homeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageindex;
@property (assign, nonatomic) BOOL isLoadingView;
@end

@implementation homeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollview setContentSize:CGSizeMake(_backview.bounds.size.width*4
                                               ,_backview.bounds.size.height)];
    self.scrollview.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView; {
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageindex.currentPage = page;
}

////////////// Fetch Featured Product coding ///////////////
#pragma mark - Action- fetchfeaturedproduct
- (IBAction)goFeaturedproduct:(id)sender {
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:@"YES" forKey:@"product_featured_flag"];
    [self FeaturedProductrequestAPI:paramDic];
    
    
}
#pragma mark - API - fetchfeaturedproduct
- (void)FeaturedProductrequestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData1:) toTarget:self withObject:dic];
}

- (void)requestData1:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_FEATUREDPRODUCT_FETCH withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.featuredproducts = [result objectForKey:@"featuredProducts"];
            

            NSLog(@"%@", appController.featuredproducts);
            
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
    FeaturedViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedView"];
    [self.navigationController pushViewController:panelController animated:YES];
    
}


#pragma mark - Action - fetchCategorylist
- (IBAction)goCategoryProduct:(id)sender {
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[commonUtils getUserDefault:@"user_name"] forKey:@"user_name"];
    [self FetchCategorylistrequestAPI:paramDic];
    
    
}
#pragma mark - API - fetchcategorylist
- (void)FetchCategorylistrequestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData2:) toTarget:self withObject:dic];
}

- (void)requestData2:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_CATEGORYLIST_FETCH withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.categorylist= [result objectForKey:@"categoryInfo"];
            
            NSLog(@"%@", appController.categorylist);
            
            [self performSelector:@selector(requestOver2) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
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
-(void) requestOver2 {
    CategorylistViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategorylistView"];
    [self.navigationController pushViewController:panelController animated:YES];
}



#pragma mark - Action - fetchBrandlist
- (IBAction)goBrandProduct:(id)sender {
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[commonUtils getUserDefault:@"user_name"] forKey:@"user_name"];
    [self FetchbrandlistrequestAPI:paramDic];
    
    
}
#pragma mark - API - fetchbrandlist
- (void)FetchbrandlistrequestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData4:) toTarget:self withObject:dic];
}

- (void)requestData4:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_BRANDLIST_FETCH withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.brandlist= [result objectForKey:@"brandInfo"];
            
            NSLog(@"%@", appController.brandlist);
           
            [self performSelector:@selector(requestOver4) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
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
-(void) requestOver4 {
    BrandlistViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"BrandlistView"];
    [self.navigationController pushViewController:panelController animated:YES];
}


////////////// Fetch New Product coding ///////////////
#pragma mark - Action - fetchNewProduct
- (IBAction)goNewproducts:(id)sender {
   
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:@"YES" forKey:@"product_new_flag"];
    [self NewProductrequestAPI:paramDic];
    
    
}
#pragma mark - API - fetchNewProduct
- (void)NewProductrequestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData3:) toTarget:self withObject:dic];
}

- (void)requestData3:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_NEWPRODUCT_FETCH withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.newproducts = [result objectForKey:@"newProducts"];
            
            [self performSelector:@selector(requestOver3) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
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
-(void) requestOver3 {
    NewViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewView"];
    [self.navigationController pushViewController:panelController animated:YES];
}

@end
