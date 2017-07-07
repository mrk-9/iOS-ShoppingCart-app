//
//  ReOrderViewController.m
//  Virtual Store
//
//  Created by Jose on 4/13/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "ReOrderViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "paymethodViewController.h"

@interface ReOrderViewController ()<UITextViewDelegate, UIScrollViewDelegate>{
       NSString *dateString ;
    NSMutableArray *productname;
    NSMutableArray *productquantity;
}
@property (weak, nonatomic) IBOutlet UITextView *orderproductquantity;
@property (weak, nonatomic) IBOutlet UITextView *ordertotalprice;
@property (weak, nonatomic) IBOutlet UITextView *orderproductname;
@property (weak, nonatomic) IBOutlet UITextView *ordershipaddress;


@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollview;
@property (assign, nonatomic) BOOL isLoadingView;
@end

@implementation ReOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollview.delegate=self;
    self.orderproductname.delegate=self;
    self.orderproductquantity.delegate=self;
    self.ordertotalprice.delegate=self;
    self.ordershipaddress.delegate=self;
    
    productname=[[NSMutableArray alloc] init];
    productquantity=[[NSMutableArray alloc] init];
    
    _orderproductname.text=appController.orderedproductname[appController.recentorderitem];
    _orderproductquantity.text=appController.orderedproductquantity[appController.recentorderitem];
    _ordertotalprice.text=appController.orderedtotalprice[appController.recentorderitem];
    _ordershipaddress.text=appController.orderedshipaddress[appController.recentorderitem];
    
    dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                dateStyle:NSDateFormatterFullStyle
                                                timeStyle:NSDateFormatterLongStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
   
    [textView becomeFirstResponder];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return [textView resignFirstResponder];
}

- (IBAction)ReOrder:(id)sender {
    
    NSString *price=_ordertotalprice.text;
    
    if([price hasPrefix:@"$"]){
        
        price=[price substringFromIndex:1];
    }
    NSLog(@"%@",price);
    appController.producttotalprice=[price doubleValue];
    
    [productname addObject:_orderproductname.text];
    [productquantity addObject:_orderproductquantity.text];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
   
    [paramDic setObject:[commonUtils getUserDefault:@"user_name"] forKey:@"order_user_name"];
    [paramDic setObject:_ordershipaddress.text forKey:@"order_ship_address"];
    [paramDic setObject:productname forKey:@"order_product_name"];
    [paramDic setObject:productquantity forKey:@"order_product_quantity"];
    [paramDic setObject:_ordertotalprice.text forKey:@"order_total_price"];
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




@end
