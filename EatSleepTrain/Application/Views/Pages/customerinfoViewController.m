//
//  customerinfoViewController.m
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "customerinfoViewController.h"
//#import "TPKeyboardAvoidingScrollView.h"
#import "shippingaddressViewController.h"

@interface customerinfoViewController (){
   
    VSDropdown *dropDownBtn1;
    VSDropdown *dropDownBtn2;

    
    NSInteger whichBtn;
    bool flag;
}
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *postalcode;
@property (weak, nonatomic) IBOutlet UITextField *phonenumber;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *province;



@property (weak, nonatomic) IBOutlet UIImageView *checkSaveimageview;
@property (assign, nonatomic) BOOL isLoadingView;
@end

@implementation customerinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadingBase=NO;
    flag=NO;
   
    // Do any additional setup after loading the view.
    
    
    dropDownBtn1 = [[VSDropdown alloc]initWithDelegate:self];
    [dropDownBtn1 setAdoptParentTheme:YES];
    [dropDownBtn1 setShouldSortItems:YES];
    
    dropDownBtn2 = [[VSDropdown alloc]initWithDelegate:self];
    [dropDownBtn2 setAdoptParentTheme:YES];
    [dropDownBtn2 setShouldSortItems:YES];
    
    
      whichBtn = -1;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

-(IBAction)shippingMethod:(id)sender{
    
    
    if([commonUtils isFormEmpty:[@[_address.text, _city.text, _country.text,_province.text, _city.text,_postalcode.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please fill the form correctly" duration:1.2];
    }
    else if([_postalcode.text length] < 6 || [_postalcode.text length] > 6) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Postal Code length must be 6 characters.Example : A1b2c3!!!" duration:2];
    }
    else{
    
    appController.address=_address.text;
    appController.country=_country.text;
    appController.city=_city.text;
    appController.postalcode=_postalcode.text;
    appController.phonenumber=_phonenumber.text;
    appController.province=_province.text;
    
     NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
     [paramDic setObject:_address.text forKey:@"ship_address"];
     [paramDic setObject:_country.text forKey:@"ship_country"];
     [paramDic setObject:_province.text forKey:@"ship_province"];
     [paramDic setObject:_city.text forKey:@"ship_city"];
     [paramDic setObject:_postalcode.text forKey:@"ship_postalcode"];
     [paramDic setObject:_phonenumber.text forKey:@"ship_phonenumber"];
     [paramDic setObject:[commonUtils getUserDefault:@"user_name"] forKey:@"user_name"];
     [self requestAPI:paramDic];
     }
    
    
}
#pragma mark - API - ShippingAddressRegister
- (void)requestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData:) toTarget:self withObject:dic];
}

- (void)requestData:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_SHIPPINGADRESS_REGISTER withJSON:(NSMutableDictionary *) params];
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
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.4];
    }
}


-(void) requestOver {
    
    shippingaddressViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"shippingaddressView"];
    [self.navigationController pushViewController:panelController animated:YES];
}




- (IBAction)checkSave:(id)sender {
    if (flag) {
        
        self.checkSaveimageview.image=[UIImage imageNamed:@"check_in_icon.png"];
        flag=NO;
        
    }
    else if(!flag){
        
        self.checkSaveimageview.image=[UIImage imageNamed:@"check_out_icon.png"];
        appController.userinfoaddress=_address.text;
        appController.userinfocountry=_country.text;
        appController.userinfoprovince=_province.text;
        appController.userinfocity=_city.text;
        appController.userinfopostalcode=_postalcode.text;
        appController.userinfophonenumber=_phonenumber.text;
        flag=YES;
        
        
    }    
    
}

-(IBAction)countrydropmenu:(id)sender{
    
    
    whichBtn = 0;
    [self showDropDownForButton1:sender adContents:appController.countryArray multipleSelection:NO];
    
}
- (void)showDropDownForButton1:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    
    [dropDownBtn1 setDrodownAnimation:rand() % 3];
    
    [dropDownBtn1 setAllowMultipleSelection:multipleSelection];
    
    [dropDownBtn1 setupDropdownForView:sender];
    
    [dropDownBtn1 setShouldSortItems:NO];
    
    [dropDownBtn1 setSeparatorColor:[UIColor darkGrayColor]];
    
    if (dropDownBtn1.allowMultipleSelection) {
        [dropDownBtn1 reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
    } else {
        if ( [sender.titleLabel.text isEqual: @""] ){
            NSArray *arraytext=[[NSArray alloc] initWithObjects:@"Canada", nil];
            [dropDownBtn1 reloadDropdownWithContents:contents andSelectedItems: arraytext];
        }
        else {
            NSArray *arraytext=[[NSArray alloc] initWithObjects:sender.titleLabel.text, nil];
            [dropDownBtn1 reloadDropdownWithContents:contents andSelectedItems: arraytext];
        }
        
        // [_dropdown reloadDropdownWithContents:contents andSelectedItems: arraytext];
        //                [_dropdown reloadDropdownWithContents:contents keyPath:@"name" selectedItems:@[sender.titleLabel.text]];
    }
    [ dropDownBtn1 setTextColor:[UIColor blackColor]];
    
    
}

-(IBAction)provincedropmenu:(id)sender{
    
    whichBtn = 1;
    
    [self showDropDownForButton2:sender adContents:appController.provinceArray multipleSelection:NO];
    
}
- (void)showDropDownForButton2:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    
    [dropDownBtn2 setDrodownAnimation:rand() % 3];
    
    [dropDownBtn2 setAllowMultipleSelection:multipleSelection];
    
    [dropDownBtn2 setupDropdownForView:sender];
    
    [dropDownBtn2 setShouldSortItems:NO];
    
    [dropDownBtn2 setSeparatorColor:[UIColor darkGrayColor]];
    
    if (dropDownBtn2.allowMultipleSelection) {
        [dropDownBtn2 reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
    } else {
        if ( [sender.titleLabel.text isEqual: @""] ){
            NSArray *arraytext=[[NSArray alloc] initWithObjects:@"AB", nil];
            [dropDownBtn2 reloadDropdownWithContents:contents andSelectedItems: arraytext];
        }
        else {
            NSArray *arraytext=[[NSArray alloc] initWithObjects:sender.titleLabel.text, nil];
            [dropDownBtn2 reloadDropdownWithContents:contents andSelectedItems: arraytext];
        }
        
        // [_dropdown reloadDropdownWithContents:contents andSelectedItems: arraytext];
        //                [_dropdown reloadDropdownWithContents:contents keyPath:@"name" selectedItems:@[sender.titleLabel.text]];
    }
    [ dropDownBtn2 setTextColor:[UIColor blackColor]];
    
    
}

#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    //UIButton *btn = (UIButton *)dropDown.dropDownView;
    //NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    //[btn setTitle:allSelectedItems forState:UIControlStateNormal];
    
    if(whichBtn == 0)
    {
        NSString *selectionKey1 = [appController.countryArray objectAtIndex:index];
        _country.text = selectionKey1;
        _country.textColor = [UIColor darkTextColor];
    }else if (whichBtn == 1){
        
        NSString *selectionKey2 = [appController.provinceArray objectAtIndex:index];
        _province.text = selectionKey2;
        _province.textColor = [UIColor darkTextColor];
        
    }
    
    
}


//- (BOOL)focusNextTextField {
//    return [self TPKeyboardAvoiding_focusNextTextField];
//    
//}



@end
