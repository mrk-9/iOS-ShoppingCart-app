//
//  singupViewController.m
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "singupViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface singupViewController (){   

    
    VSDropdown *dropDownBtn1;
    VSDropdown *dropDownBtn2;
    VSDropdown *dropDownBtn3;
    
    NSString *dateString ;
    NSInteger whichBtn;

}
@property (weak, nonatomic) IBOutlet UIImageView *orderimage;
@property (weak, nonatomic) IBOutlet UILabel *clicklabel;

@property (strong, nonatomic) IBOutlet UITextField *userFirstNameTxtField;
@property (strong, nonatomic) IBOutlet UITextField *userLastNameTxtField;
@property (strong, nonatomic) IBOutlet UITextField *userEmailAddressTxtField;
@property (strong, nonatomic) IBOutlet UITextField *userPasswordTxtField;

@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *age;

@property (weak, nonatomic) IBOutlet UIView *dateview;
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker;

//@property (strong, nonatomic) IBOutlet UIImageView *userProfileImageView;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainscrollView;
@property (strong, nonatomic) UIImagePickerController *pickerController;

@property (assign, nonatomic) BOOL noCamera, isEditing;



@end

@implementation singupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                dateStyle:NSDateFormatterFullStyle
                                                timeStyle:NSDateFormatterLongStyle];
    
   
    
    [commonUtils cropCircleImage:_orderimage];
    [commonUtils setCircleBorderImage:_orderimage withBorderWidth:3 withBorderColor:RGBA(255, 0, 0, 1)];
    // Do any additional setup after loading the view.
    
    dropDownBtn1 = [[VSDropdown alloc]initWithDelegate:self];
    [dropDownBtn1 setAdoptParentTheme:YES];
    [dropDownBtn1 setShouldSortItems:YES];
    
    dropDownBtn2 = [[VSDropdown alloc]initWithDelegate:self];
    [dropDownBtn2 setAdoptParentTheme:YES];
    [dropDownBtn2 setShouldSortItems:YES];
    
    dropDownBtn3 = [[VSDropdown alloc]initWithDelegate:self];
    [dropDownBtn3 setAdoptParentTheme:YES];
    [dropDownBtn3 setShouldSortItems:YES]; 
    

    whichBtn = -1;
   
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-dropmenu(age, gender) action
-(IBAction)agedropmenu:(id)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dateview.frame = CGRectMake(self.dateview.frame.origin.x, self.view.frame.size.height-self.dateview.frame.size.height, self.dateview.frame.size.width, self.dateview.frame.size.height);
    } completion:^(BOOL finished) { }];
    
}
- (IBAction)addage:(id)sender {
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"dd-MM-yyyy"];
    NSString *formatdate=[date stringFromDate:self.datepicker.date];
    self.age.text=formatdate;
   
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dateview.frame = CGRectMake(self.dateview.frame.origin.x, self.view.frame.size.height, self.dateview.frame.size.width, self.dateview.frame.size.height);
    } completion:^(BOOL finished) { }];
    
}


-(IBAction)genderdropmenu:(id)sender{
    
   
    whichBtn = 0;
     [self showDropDownForButton1:sender adContents:appController.categoryArraygender multipleSelection:NO];
    
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
            NSArray *arraytext=[[NSArray alloc] initWithObjects:@"Male", nil];
            [dropDownBtn1 reloadDropdownWithContents:contents andSelectedItems: arraytext];
        }
        else {
            NSArray *arraytext=[[NSArray alloc] initWithObjects:sender.titleLabel.text, nil];
            [dropDownBtn1 reloadDropdownWithContents:contents andSelectedItems: arraytext];
        }
        
        
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
            NSArray *arraytext=[[NSArray alloc] initWithObjects:@"Canada", nil];
            [dropDownBtn1 reloadDropdownWithContents:contents andSelectedItems: arraytext];
        }
        else {
            NSArray *arraytext=[[NSArray alloc] initWithObjects:sender.titleLabel.text, nil];
            [dropDownBtn1 reloadDropdownWithContents:contents andSelectedItems: arraytext];
        }
        
    }
    [ dropDownBtn2 setTextColor:[UIColor blackColor]];
    
    
}

#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    
    if(whichBtn == 0)
    {
    NSString *selectionKey1 = [appController.categoryArraygender objectAtIndex:index];
     _gender.text = selectionKey1;
    _gender.textColor = [UIColor darkTextColor];
    }else if (whichBtn == 1){
    
        NSString *selectionKey2 = [appController.provinceArray objectAtIndex:index];
        _gender.text = selectionKey2;
        _gender.textColor = [UIColor darkTextColor];

    }

    
}
#pragma mark-add profile photo action
- (IBAction)onClickAddProfilePhotoBtn:(id)sender {
    _clicklabel.hidden=YES;
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Take a Photo", @"Photo Library" ,nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark Actionsheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self onAddImageFromCamera];
    }else if (buttonIndex == 1)
    {
        [self onAddImageFromLibrary];
    }

}

- (void)onAddImageFromCamera
{
    if (_noCamera) {
        
        [commonUtils showVAlertSimple:@"Warning" body:@"Your device has no camera" duration:1.0f];
        return;
    }
    
    [self performSelector:@selector(showCamera) withObject:nil afterDelay:1];
}

- (void) showCamera{
    
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    _pickerController.allowsEditing = YES;
    _pickerController.delegate = self;
    
    [self presentViewController:_pickerController animated:YES completion:^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
    }];
    
}

- (void)onAddImageFromLibrary
{
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    _pickerController.allowsEditing = NO;
    _pickerController.delegate = self;
    [self presentViewController:_pickerController animated:YES completion:nil];
    
    
}
//// Image Picker Delegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!resultImage) {
            resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        CGSize imageSize;
        
        imageSize = CGSizeMake(100, 100);
        
       
        UIGraphicsBeginImageContext( imageSize );
        [resultImage drawInRect:CGRectMake(0,0,imageSize.width,imageSize.height)];
        UIImage* realfrontImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [_orderimage setImage:realfrontImage];
        
        appController.currentUserPhoto=realfrontImage;
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onClickNextBtn:(id)sender {
    
    appController.signflag=YES;
    appController.menuPhotoTag=@"1";
    appController.firstname=_userFirstNameTxtField.text;
    appController.lastname=_userLastNameTxtField.text;
    
    if (_orderimage.image == nil) {
        [commonUtils showVAlertSimple:@"Warning!" body:@"Please take your photo" duration:1.2f];
        return;
    }
    
    
    if([commonUtils isFormEmpty:[@[_userEmailAddressTxtField.text, _userFirstNameTxtField.text, _userLastNameTxtField.text, _userPasswordTxtField.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please fill the form correctly" duration:1.2];
    } else if([_userPasswordTxtField.text length] < 6 || [_userPasswordTxtField.text length] > 10) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password length must be between 6 and 10 characters" duration:1.2];
    } else if(![commonUtils validateEmail:_userEmailAddressTxtField.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please type email correctly" duration:1.2];
  
    } else {
        
       [self saveUserProfileData];
    }
    
    
}


- (void) saveUserProfileData{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:_userFirstNameTxtField.text forKey:@"user_first_name"];
    [paramDic setObject:_userLastNameTxtField.text forKey:@"user_last_name"];
    [paramDic setObject:_userEmailAddressTxtField.text forKey:@"user_email"];
    [paramDic setObject:_userPasswordTxtField.text forKey:@"user_password"];
    if ([_gender.text isEqualToString:@"Male"]) {
        [paramDic setObject:@"Male" forKey:@"user_gender"];
    }else if([_gender.text isEqualToString:@"Female"]){
        [paramDic setObject:@"Female" forKey:@""];

    }
    [paramDic setObject:_age.text forKey:@"user_birthday"];
    [paramDic setObject:dateString forKey:@"user_signup_date"];
    
    
    NSString *photo = [ commonUtils encodeToBase64String:_orderimage.image byCompressionRatio:0.5];
    [paramDic setObject:photo forKey:@"user_profile_photo"];
    
    [paramDic setObject:@"1" forKey:@"signup_mode"];
    
    if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
        
        [paramDic setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
        [self requestAPI:paramDic];
        
    } else {
        [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token." duration:2.0f done:^(DoAlertView *alertView) {
            
            [self requestAPI:paramDic];
        }];
    }
}


#pragma mark - API - Sign Up
- (void)requestAPI:(NSMutableDictionary *)dic {
    self.isLoadingUserBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataSignUp:) toTarget:self withObject:dic];
}

- (void)requestDataSignUp:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_SIGNUP withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingUserBase = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            NSLog(@"%@", appController.currentUser);
            
            [commonUtils setUserDefault:@"user_name" withFormat:[appController.currentUser objectForKey:@"user_name"]];
            [commonUtils setUserDefault:@"user_first_name" withFormat:[appController.currentUser objectForKey:@"user_first_name"]];
            [commonUtils setUserDefault:@"user_last_name" withFormat:[appController.currentUser objectForKey:@"user_last_name"]];
            [commonUtils setUserDefault:@"user_photo_url" withFormat:[appController.currentUser objectForKey:@"user_photo_url"]];
            [commonUtils setUserDefault:@"user_gender" withFormat:[appController.currentUser objectForKey:@"user_gender"]];
            [commonUtils setUserDefault:@"user_birthday" withFormat:[appController.currentUser objectForKey:@"user_birthday"]];
            [commonUtils setUserDefault:@"user_password" withFormat:[appController.currentUser objectForKey:@"user_password"]];
            
//            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
//            [commonUtils showVAlertSimple:@"User register Succeed" body:msg duration:1.4];
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
    [self navToMainView];
}



@end
