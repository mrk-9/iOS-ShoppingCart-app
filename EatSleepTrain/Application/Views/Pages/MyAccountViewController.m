//
//  MyAccountViewController.m
//  Virtual Store
//
//  Created by Jose on 4/13/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "MyAccountViewController.h"
#import "loginViewController.h"

@interface MyAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *shipaddress;
@property (weak, nonatomic) IBOutlet UITextField *shipcountry;
@property (weak, nonatomic) IBOutlet UITextField *shipprovince;
@property (weak, nonatomic) IBOutlet UITextField *shipcity;
@property (weak, nonatomic) IBOutlet UITextField *shippostalcode;
@property (weak, nonatomic) IBOutlet UITextField *shipphonenumber;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *birthday;
@property (weak, nonatomic) IBOutlet UITextField *newpassword;
@property (weak, nonatomic) IBOutlet UITextField *oldpassword;


@property (assign, nonatomic) BOOL isLoadingView;
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _shipaddress.text=appController.userinfoaddress;
    _shipcountry.text=appController.userinfocountry;
    _shipcity.text=appController.userinfocity;
    _shipprovince.text=appController.userinfoprovince;
    _shippostalcode.text=appController.userinfopostalcode;
    _shipphonenumber.text=appController.userinfophonenumber;
    
    _username.text=[commonUtils getUserDefault:@"user_name"];
    _gender.text=[commonUtils getUserDefault:@"user_gender"];
    _birthday.text=[commonUtils getUserDefault:@"user_birthday"];
    _oldpassword.text=[commonUtils getUserDefault:@"user_password"];
    if([_gender.text isEqualToString:@"0"]){
         _gender.text=@"";
        
    }
    if([_birthday.text isEqualToString:@"0"]){
        
        _birthday.text=@"";
        
    }
    if ([_oldpassword.text isEqualToString:@"0"]){
        
        _oldpassword.text=@"";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addAddress:(id)sender {
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_shipaddress.text forKey:@"ship_address"];
    [paramDic setObject:_shipcountry.text forKey:@"ship_country"];
    [paramDic setObject:_shipprovince.text forKey:@"ship_province"];
    [paramDic setObject:_shipcity.text forKey:@"ship_city"];
    [paramDic setObject:_shippostalcode.text forKey:@"ship_postalcode"];
    [paramDic setObject:_shipphonenumber.text forKey:@"ship_phonenumber"];
    [paramDic setObject:[commonUtils getUserDefault:@"user_name"] forKey:@"user_name"];
    [self requestAPI:paramDic];
}

#pragma mark - API - ShippingAddressRegister
- (void)requestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData1:) toTarget:self withObject:dic];
}

- (void)requestData1:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_SHIPPINGADRESS_REGISTER withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            [self performSelector:@selector(requestOver1) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.4];
    }
}


-(void) requestOver1{
    
    NSString *msg = @"Added Shipping Address Successfully";
    [commonUtils showVAlertSimple:@"Succeed" body:msg duration:1.4];

}

- (IBAction)changepassword:(id)sender {
    
    if([_newpassword.text length] < 6 || [_newpassword.text length] > 10) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password length must be between 6 and 10 characters" duration:1.2];
    }else{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_username.text forKey:@"user_name"];
    [paramDic setObject:_gender.text forKey:@"user_gender"];
    [paramDic setObject:_birthday.text forKey:@"user_birthday"];
    [paramDic setObject:_oldpassword.text forKey:@"user_password_old"];
    [paramDic setObject:_newpassword.text forKey:@"user_password_new"];
    [self changepasswordrequestAPI:paramDic];
    }
    
}
#pragma mark - API - ChangePassword
- (void)changepasswordrequestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData:) toTarget:self withObject:dic];
}

- (void)requestData:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_USER_CHANGE_PASSWORD withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
//            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
//            [commonUtils showVAlertSimple:@"Succeed" body:msg duration:1.4];
            [self performSelector:@selector(requestOver) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
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
-(void) requestOver{
    
    loginViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    [self.navigationController pushViewController:panelController animated:YES];
}

    



@end
