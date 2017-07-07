//
//  loginViewController.m
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "loginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "singupViewController.h"

@interface loginViewController (){
    
    bool checkflag;
    NSString  *dateString;
}

@property (strong, nonatomic) IBOutlet UITextField *emailAdressTxtField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UIImageView *checkimageview;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                dateStyle:NSDateFormatterFullStyle
                                                timeStyle:NSDateFormatterLongStyle];
    
    NSLog(@"%@",dateString);
    
    checkflag=NO;
    _emailAdressTxtField.delegate = self;
    _passwordTxtField.delegate = self;
    if([[commonUtils getUserDefault:@"rememberflag"] isEqualToString:@"1"]){
        
    _emailAdressTxtField.text=[commonUtils getUserDefault:@"user_email"];
    _passwordTxtField.text=[commonUtils getUserDefault:@"user_password"];
    
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)rememberCheck:(id)sender {
    
    if (checkflag) {
        
        self.checkimageview.image=[UIImage imageNamed:@"check_in_icon.png"];
        checkflag=NO;
    }
    else if(!checkflag){
        
        self.checkimageview.image=[UIImage imageNamed:@"check_out_icon.png"];
        [commonUtils setUserDefault:@"user_email" withFormat:_emailAdressTxtField.text];
        [commonUtils setUserDefault:@"user_password" withFormat:_passwordTxtField.text];
        [commonUtils setUserDefault:@"rememberflag" withFormat:@"1"];
        checkflag=YES;
        
    }
}




-(IBAction)loginFB:(id)sender{
   [commonUtils setUserDefault:@"rememberflag" withFormat:@"1"];
    appController.signflag=NO;
  
    [commonUtils setUserDefault:@"menuPhotoTag" withFormat:@"3"];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_birthday", @"user_photos"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             
             
             NSLog(@"Logged in with token : @%@", result.token);
             if ([result.grantedPermissions containsObject:@"email"]) {
                 NSLog(@"result is:%@",result);
                 [self fetchUserInfo];
             }
         }
     }];
    
}
   
- (void)fetchUserInfo {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken] tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, gender, bio, location, friends, hometown, friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"facebook fetched info : %@", result);
                 
                 NSDictionary *temp = (NSDictionary *)result;
                 NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                 [userInfo setObject:[temp objectForKey:@"id"] forKey:@"user_facebook_id"];
                 
                 [userInfo setObject:[temp objectForKey:@"email"] forKey:@"user_email"];
        
                 [userInfo setObject:[temp objectForKey:@"gender"] forKey:@"user_gender"];
                
               
                 if([commonUtils checkKeyInDic:@"first_name" inDic:[temp mutableCopy]]) {
                     [userInfo setObject:[temp objectForKey:@"first_name"] forKey:@"user_firstname"];
                 }
                 if([commonUtils checkKeyInDic:@"last_name" inDic:[temp mutableCopy]]) {
                     [userInfo setObject:[temp objectForKey:@"last_name"] forKey:@"user_lastname"];
                 }
                 
                 
                 if([commonUtils getUserDefault:@"currentLatitude"] && [commonUtils getUserDefault:@"currentLongitude"]) {
                     [userInfo setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"user_latitude"];
                     [userInfo setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"user_longitude"];
                 }
                
                 NSString *fbProfilePhoto = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [temp objectForKey:@"id"]];
                 [userInfo setObject:fbProfilePhoto forKey:@"user_profilephoto_url"];
                 [userInfo setObject:dateString forKey:@"user_signup_date"];
                 

                 [userInfo setObject:@"2" forKey:@"signup_mode"];
                 
                 if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
                     [userInfo setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
                     
                     [self requestData:userInfo];
                     
                 } else {
                     [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token." duration:2.0f done:^(DoAlertView *alertView) {
                         
                         [self requestData:userInfo];
                     }];
                 }
                 
             } else {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    
}

#pragma mark - API Request - User Signup After FB Login


- (void) requestData:(id)params{
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_SIGNUP withJSON:(NSMutableDictionary *) params];
    
    self.isLoadingUserBase = NO;
    [commonUtils hideActivityIndicator];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            [commonUtils setUserDefault:@"user_name" withFormat:[appController.currentUser objectForKey:@"user_name"]];
            [commonUtils setUserDefault:@"user_first_name" withFormat:[appController.currentUser objectForKey:@"user_first_name"]];
            [commonUtils setUserDefault:@"user_last_name" withFormat:[appController.currentUser objectForKey:@"user_last_name"]];
            [commonUtils setUserDefault:@"user_gender" withFormat:[appController.currentUser objectForKey:@"user_gender"]];
            [commonUtils setUserDefault:@"user_birthday" withFormat:[appController.currentUser objectForKey:@"user_birthday"]];
            [commonUtils setUserDefault:@"user_password" withFormat:[appController.currentUser objectForKey:@"user_password"]];
            [commonUtils setUserDefault:@"user_photo_url" withFormat:[appController.currentUser objectForKey:@"user_photo_url"]];
            

            NSLog(@"%@", appController.currentUser);
            [self requestOver1];
        }
        else if([status intValue] == 2){
            
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            [commonUtils setUserDefault:@"user_name" withFormat:[appController.currentUser objectForKey:@"user_name"]];
            [commonUtils setUserDefault:@"user_first_name" withFormat:[appController.currentUser objectForKey:@"user_first_name"]];
            [commonUtils setUserDefault:@"user_last_name" withFormat:[appController.currentUser objectForKey:@"user_last_name"]];
            [commonUtils setUserDefault:@"user_gender" withFormat:[appController.currentUser objectForKey:@"user_gender"]];
            [commonUtils setUserDefault:@"user_birthday" withFormat:[appController.currentUser objectForKey:@"user_birthday"]];
            [commonUtils setUserDefault:@"user_password" withFormat:[appController.currentUser objectForKey:@"user_password"]];
            [commonUtils setUserDefault:@"user_photo_url" withFormat:[appController.currentUser objectForKey:@"user_photo_url"]];

//            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
//            [commonUtils showVAlertSimple:@"User login Succeed" body:msg duration:1.4];
            
            [self requestOver1];
        }
        else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Warning" body:msg duration:1.4];
        }
    } else {
        
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
    
    
}

- (void) requestOver1{
    [self navToMainView];
}



- (IBAction)onClickSignInBtn:(id)sender {
    
    appController.signflag=YES;
  //  appController.menuPhotoTag=@"2";
    [commonUtils setUserDefault:@"menuPhotoTag" withFormat:@"2"];
    appController.email=self.emailAdressTxtField.text;
    appController.password=self.passwordTxtField.text;
    if(self.isLoadingUserBase) return;
    
    if([commonUtils isFormEmpty:[@[_emailAdressTxtField.text, _passwordTxtField.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please fill the form correctly" duration:1.2];
    } else if([_passwordTxtField.text length] < 6 || [_passwordTxtField.text length] > 10) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password length must be between 6 and 10 characters" duration:1.2];
    } else if([commonUtils validateEmail:_emailAdressTxtField.text]){
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
//        [paramDic setObject:@"1001" forKey:@"user_phone"];
        [paramDic setObject:_emailAdressTxtField.text forKey:@"user_email"];
        [paramDic setObject:_passwordTxtField.text forKey:@"user_password"];
        
        if([commonUtils getUserDefault:@"currentLatitude"] && [commonUtils getUserDefault:@"currentLongitude"]) {
            [paramDic setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"user_latitude"];
            [paramDic setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"user_longitude"];
        }
        
        if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
            [paramDic setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
        }
        
        [self requestAPILogIn:paramDic];
        
    } else if([commonUtils validatePhoneNumber:_emailAdressTxtField.text]){
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:_emailAdressTxtField.text forKey:@"user_phone"];
        [paramDic setObject:@"1001" forKey:@"user_email"];
        [paramDic setObject:_passwordTxtField.text forKey:@"user_password"];
        
        if([commonUtils getUserDefault:@"currentLatitude"] && [commonUtils getUserDefault:@"currentLongitude"]) {
            [paramDic setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"user_latitude"];
            [paramDic setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"user_longitude"];
        }
        
        if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
            [paramDic setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
            [self requestAPILogIn:paramDic];
            
        } else {
            [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\nTherefore, you will not be able to receive notification for the new acceped gigs." duration:2.0f done:^(DoAlertView *alertView) {
                [self requestAPILogIn:paramDic];
            }];
        }
    } else{
        
        [commonUtils showVAlertSimple:@"Warning" body:@"Please type your email address or phone numer correctly" duration:1.2];
    }
}


#pragma mark - API - Sign In

- (void)requestAPILogIn:(NSMutableDictionary *) dic {
    
    self.isLoadingUserBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataLogin:) toTarget:self withObject:dic];
    
}
- (void)requestDataLogin:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_SIGNIN withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingUserBase = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
           
            
            [commonUtils setUserDefault:@"user_photo_url" withFormat:[appController.currentUser objectForKey:@"user_photo_url"]];
            [commonUtils setUserDefault:@"user_name" withFormat:[appController.currentUser objectForKey:@"user_name"]];
            [commonUtils setUserDefault:@"user_first_name" withFormat:[appController.currentUser objectForKey:@"user_first_name"]];
            [commonUtils setUserDefault:@"user_last_name" withFormat:[appController.currentUser objectForKey:@"user_last_name"]];
            [commonUtils setUserDefault:@"user_gender" withFormat:[appController.currentUser objectForKey:@"user_gender"]];
            [commonUtils setUserDefault:@"user_birthday" withFormat:[appController.currentUser objectForKey:@"user_birthday"]];
            [commonUtils setUserDefault:@"user_password" withFormat:[appController.currentUser objectForKey:@"user_password"]];
            
            NSLog(@"%@", appController.currentUser);
//            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
//            [commonUtils showVAlertSimple:@"User login Succeed" body:msg duration:1.4];
            [self performSelector:@selector(requestOverNavToMainView) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
    
}

- (void) requestOverNavToMainView{
    
    [self navToMainView];
}

- (IBAction)onClickUserFormSubmit:(id)sender {
    
    if(self.isLoadingUserBase) return;
    if([commonUtils isFormEmpty:[@[_emailAdressTxtField.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please input your email address" duration:1.2];
    } else if(![commonUtils validateEmail:_emailAdressTxtField.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Email address is not in a vaild format" duration:1.2];
    } else {
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:_emailAdressTxtField.text forKey:@"user_email"];
        [self requestAPI:paramDic];
    }
}

#pragma mark - API Request - User Retrieve Password
- (void)requestAPI:(NSMutableDictionary *)dic {
    self.isLoadingUserBase = YES;
    [commonUtils showActivityIndicatorThird:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData1:) toTarget:self withObject:dic];
}
- (void)requestData1:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_RETRIEVE_PASSWORD withJSON:(NSMutableDictionary *) params];
    self.isLoadingUserBase = NO;
    [commonUtils hideActivityIndicator];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 0) {
            [self performSelector:@selector(requestOver) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }
}
- (void)requestOver {
    
    [_emailAdressTxtField resignFirstResponder];
    [appController.vAlert doAlert:@"Success"
                             body:@"Your new password will arrive by email"
                         duration:1.5f
                             done:^(DoAlertView *alertView) {
                                 [self.navigationController popViewControllerAnimated:YES];
                                 return;
                             }
     ];
}

#pragma mark - TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [textField becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
