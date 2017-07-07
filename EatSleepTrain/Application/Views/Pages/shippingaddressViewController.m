//
//  shippingaddressViewController.m
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "shippingaddressViewController.h"
#import "paymethodViewController.h"

@interface shippingaddressViewController (){
    
    bool flag;
    NSString *dateString;
}
@property (strong, nonatomic) IBOutlet UILabel *fistname;
@property (strong, nonatomic) IBOutlet UILabel *lastname;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *postalcode;
@property (strong, nonatomic) IBOutlet UILabel *country;
@property (strong, nonatomic) IBOutlet UILabel *phonenumber;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *province;

@property (strong, nonatomic) IBOutlet UIImageView *checkInterShipImageview;
@property (strong, nonatomic) IBOutlet UILabel *totalprice;
@property (assign, nonatomic) BOOL isLoadingView;
@end

@implementation shippingaddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fistname.text=[commonUtils getUserDefault:@"user_first_name"];
    _lastname.text=[commonUtils getUserDefault:@"user_last_name"];
    _address.text=appController.address;
    _postalcode.text=appController.postalcode;
    _city.text=appController.city;
    _phonenumber.text=appController.phonenumber;
    _country.text=appController.country;
    _province.text=appController.province;
    
    NSString *price=[NSString stringWithFormat:@"$%.2f", appController.producttotalprice];
    _totalprice.text=price;
    
    flag=NO;
    
    dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                dateStyle:NSDateFormatterFullStyle
                                                timeStyle:NSDateFormatterLongStyle];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- actions
-(IBAction)editShippigAddress:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)paymentMethod:(id)sender{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
 
    [paramDic setObject:[commonUtils getUserDefault:@"user_name"] forKey:@"order_user_name"];
    [paramDic setObject:_address.text forKey:@"order_ship_address"];
    
    [paramDic setObject:appController.productnameArray forKey:@"order_product_name"];
    NSLog(@"%@", appController.productnameArray);
    [paramDic setObject:appController.productquantity forKey:@"order_product_quantity"];
    NSLog(@"%@",appController.productquantity);
    [paramDic setObject:_totalprice.text forKey:@"order_total_price"];
    [paramDic setObject:[commonUtils getUserDefault:@"currentuserlocation"] forKey:@"user_location"];
    [paramDic setObject:dateString forKey:@"order_date"];
    [self requestAPI:paramDic];
}

#pragma mark - API - productRegister
- (void)requestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData:) toTarget:self withObject:dic];
}

- (void)requestData:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_ORDERINFO_REGISTER withJSON:(NSMutableDictionary *) params];
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
    
    paymethodViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"paymethodView"];
    [self.navigationController pushViewController:panelController animated:YES];
}




- (IBAction)checkInterShip:(id)sender {
    if (flag) {
        
        self.checkInterShipImageview.image=[UIImage imageNamed:@"check_in_icon.png"];
        flag=NO;
    }
    else if(!flag){
        
        self.checkInterShipImageview.image=[UIImage imageNamed:@"check_out_icon.png"];
        flag=YES;
    }
        
}

@end
