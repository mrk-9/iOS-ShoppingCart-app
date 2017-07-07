//
//  paymethodViewController.m
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "paymethodViewController.h"

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentProduction;

@interface paymethodViewController (){

    bool flag1, flag2, flag3, flag4;
    
}
@property (weak, nonatomic) IBOutlet UILabel *totalamount;
@property (weak, nonatomic) IBOutlet UIImageView *checkCardimageview;
@property (weak, nonatomic) IBOutlet UIImageView *checkPaypalimageview;
@property (weak, nonatomic) IBOutlet UIImageView *checkSameShipAddimagview;
@property (weak, nonatomic) IBOutlet UIImageView *checkUseDiffAddinageview;

@property (weak, nonatomic) IBOutlet UITextField *cardnumber;
@property (weak, nonatomic) IBOutlet UITextField *cardname;
@property (weak, nonatomic) IBOutlet UITextField *cardmm;
@property (weak, nonatomic) IBOutlet UITextField *cardcvv;

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;
@end

@implementation paymethodViewController

- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    flag1=NO;
    flag2=NO;
    flag3=NO;
    flag4=NO;
    
    self.cardnumber.delegate=self;
    self.cardname.delegate=self;
    self.cardmm.delegate=self;
    self.cardcvv.delegate=self;
    
    NSString *price=[NSString stringWithFormat:@"$%.2f", appController.producttotalprice];
    _totalamount.text=price;

    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    
//#if HAS_CARDIO
//    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
//    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
//    // for more details.
//    _payPalConfig.acceptCreditCards = YES;
//#else
    _payPalConfig.acceptCreditCards = YES;
//#endif
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - payment actions

-(IBAction)creditCard:(id)sender{
    
    
}

-(IBAction)payPal:(id)sender{
    
    if (flag2) {
        
        self.checkPaypalimageview.image=[UIImage imageNamed:@"check_in_icon.png"];
        flag2=NO;
    }
    else if(!flag2){
        
        self.checkPaypalimageview.image=[UIImage imageNamed:@"check_out_icon.png"];
        flag2=YES;


    
    
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
//    PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
//                                    withQuantity:2
//                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"84.99"]
//                                    withCurrency:@"USD"
//                                         withSku:@"Hip-00037"];
//    PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
//                                    withQuantity:1
//                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
//                                    withCurrency:@"USD"
//                                         withSku:@"Hip-00066"];
//    PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
//                                    withQuantity:1
//                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
//                                    withCurrency:@"USD"
//                                         withSku:@"Hip-00291"];
//    NSArray *items = @[item1, item2, item3];
//    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
//    
//    // Optional: include payment details
//    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
//    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
//    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
//                                                                               withShipping:shipping
//                                                                                    withTax:tax];
//    
//    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount=[NSNumber numberWithDouble:appController.producttotalprice];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"TOTAL AMOUNT";
//    payment.items = items;  // if not including multiple items, then leave payment.items as nil
//    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
    }
}
#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

#pragma mark - Helpers

- (void)showSuccess {
    self.successView.hidden = NO;
    self.successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    self.successView.alpha = 0.0f;
    [UIView commitAnimations];
}


#pragma mark - TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    textField.keyboardAppearance=UIKeyboardAppearanceDark;
    [textField becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

#pragma mark - check Creditcart and Paypal
- (IBAction)checkCard:(id)sender {
    
    if (flag1) {
        
        self.checkCardimageview.image=[UIImage imageNamed:@"check_in_icon.png"];
        flag1=NO;
    }
    else if(!flag1){
        
        self.checkCardimageview.image=[UIImage imageNamed:@"check_out_icon.png"];
        flag1=YES;
    }
    
    
}

- (IBAction)sameShipaddress:(id)sender {
    if (flag3) {
        
        self.checkSameShipAddimagview.image=[UIImage imageNamed:@"check_in_icon.png"];
        flag3=NO;
    }
    else if(!flag3){
        
        self.checkSameShipAddimagview.image=[UIImage imageNamed:@"check_out_icon.png"];
        flag3=YES;
    }
    
    
}

- (IBAction)useDifBilAdd:(id)sender {
    
    if (flag4) {
        
        self.checkUseDiffAddinageview.image=[UIImage imageNamed:@"check_in_icon.png"];
        flag4=NO;
    }
    else if(!flag4){
        
        self.checkUseDiffAddinageview.image=[UIImage imageNamed:@"check_out_icon.png"];
        flag4=YES;
    }
    
}

- (IBAction)order:(id)sender {
    
    
    NSString *msg = @"Success";
    [commonUtils showVAlertSimple:@"Thank you for your Order" body:msg duration:1.4];
    homeViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
    [self.navigationController pushViewController:panelController animated:YES];
}

@end
