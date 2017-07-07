//
//  scanViewController.m
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "scanViewController.h"
#import "featureViewController.h"
#import "MTBBarcodeScanner.h"
@interface scanViewController ()<UINavigationControllerDelegate>{
    
    bool flag;
    NSString *productImageData;
    
}

@property (nonatomic, weak) IBOutlet UIView *previewView;
@property (nonatomic, weak) IBOutlet UIButton *toggleScanningButton;
@property (nonatomic, weak) IBOutlet UILabel *instructions;
@property (nonatomic, weak) IBOutlet UIView *viewOfInterest;

@property (nonatomic, strong) MTBBarcodeScanner *scanner;
@property (nonatomic, strong) NSMutableDictionary *overlayViews;
@property (nonatomic, assign) BOOL didShowAlert;


@property (weak, nonatomic) IBOutlet UILabel *barcodenumber;
@property (assign, nonatomic) BOOL isLoadingView;

@end

@implementation scanViewController

#pragma mark - Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    flag=NO;
    self.previewView.hidden=YES;
    self.viewOfInterest.hidden=YES;
    self.isLoadingView = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    if (!self.didShowAlert && !self.instructions) {
    //        [[[UIAlertView alloc] initWithTitle:@"Example"
    //                                    message:@"To view this example, point the camera at the sample barcodes on the official MTBBarcodeScanner README."
    //                                   delegate:nil
    //                          cancelButtonTitle:@"Ok"
    //                          otherButtonTitles:nil] show];
    //    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.scanner stopScanning];
    [super viewWillDisappear:animated];
}

#pragma mark - Scanner

- (MTBBarcodeScanner *)scanner {
    if (!_scanner) {
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:_previewView];
    }
    return _scanner;
}

#pragma mark - Overlay Views

- (NSMutableDictionary *)overlayViews {
    if (!_overlayViews) {
        _overlayViews = [[NSMutableDictionary alloc] init];
    }
    return _overlayViews;
}

#pragma mark - Scanning

- (void)startScanning {
    self.previewView.hidden=NO ;
    self.viewOfInterest.hidden=NO;
    self.scanner.didStartScanningBlock = ^{
        NSLog(@"The scanner started scanning!");
    };
    
    self.scanner.didTapToFocusBlock = ^(CGPoint point){
        NSLog(@"The user tapped the screen to focus. \
              Here we could present a view at %@", NSStringFromCGPoint(point));
    };
    
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        [self drawOverlaysOnCodes:codes];
    }];
    
    // Optionally set a rectangle of interest to scan codes. Only codes within this rect will be scanned.
    self.scanner.scanRect = self.viewOfInterest.frame;
    
    [self.toggleScanningButton setTitle:@"STOP SCANNING" forState:UIControlStateNormal];
    self.toggleScanningButton.backgroundColor = [UIColor redColor];
}

- (void)drawOverlaysOnCodes:(NSArray *)codes {
    // Get all of the captured code strings
    NSMutableArray *codeStrings = [[NSMutableArray alloc] init];
    for (AVMetadataMachineReadableCodeObject *code in codes) {
        if (code.stringValue) {
            [codeStrings addObject:code.stringValue];
        }
    }
    
    // Remove any code overlays no longer on the screen
    for (NSString *code in self.overlayViews.allKeys) {
        if ([codeStrings indexOfObject:code] == NSNotFound) {
            // A code that was on the screen is no longer
            // in the list of captured codes, remove its overlay
            [self.overlayViews[code] removeFromSuperview];
            [self.overlayViews removeObjectForKey:code];
        }
    }
    
    for (AVMetadataMachineReadableCodeObject *code in codes) {
        UIView *view = nil;
        NSString *codeString = code.stringValue;
        
        if (codeString) {
            
            if (self.overlayViews[codeString]) {
                // The overlay is already on the screen
                view = self.overlayViews[codeString];
                
                // Move it to the new location
                view.frame = code.bounds;
                
            } else {
                // First time seeing this code
                BOOL isValidCode = [self isValidCodeString:codeString];
                
                // Create an overlay
                UIView *overlayView = [self overlayForCodeString:codeString
                                                          bounds:code.bounds
                                                           valid:isValidCode];
                self.overlayViews[codeString] = overlayView;
                
                // Add the overlay to the preview view
                [self.previewView addSubview:overlayView];
                
            }
        }
    }
}

- (BOOL)isValidCodeString:(NSString *)codeString {
    BOOL stringIsValid = ([codeString rangeOfString:@"Valid"].location != NSNotFound);
    return stringIsValid;
}

- (UIView *)overlayForCodeString:(NSString *)codeString bounds:(CGRect)bounds valid:(BOOL)valid {
    UIColor *viewColor = valid ? [UIColor greenColor] : [UIColor redColor];
    UIView *view = [[UIView alloc] initWithFrame:bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    
    // Configure the view
    view.layer.borderWidth = 5.0;
    view.backgroundColor = [viewColor colorWithAlphaComponent:0.75];
    view.layer.borderColor = viewColor.CGColor;
    
    // Configure the label
    label.font = [UIFont boldSystemFontOfSize:12];
    label.text = codeString;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    _barcodenumber.text=codeString;
  
    // server request fetchproductinfo from barcode
    if (flag==NO) {
     
         NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:_barcodenumber.text forKey:@"product_barcode"];
        [self requestAPI:paramDic];
        [self stopScanning];
        
    }
    
//if ([codeString isEqualToString:@"0836722005210"] && flag==NO) {
//        
//        flag=YES;
//        UIImage* tempImage = [[UIImage alloc] init];
//        tempImage = [UIImage imageNamed:@"am_product_grande.jpeg"];
//        NSData *data = UIImagePNGRepresentation(tempImage);
//        productImageData = [ commonUtils encodeToBase64String:tempImage byCompressionRatio:0.5];
//        [appController.scanproductsaveimage addObject:data];
//        [self compare];
//        [self stopScanning];
//
//        
//    }
//    else if ([codeString isEqualToString:@"0836722007061"] && flag==NO) {
//        flag=YES;
//        UIImage* tempImage = [[UIImage alloc] init];
//        tempImage = [UIImage imageNamed:@"2.0_grande.png"];
//        NSData *data = UIImagePNGRepresentation(tempImage);
//        productImageData = [ commonUtils encodeToBase64String:tempImage byCompressionRatio:0.5];
//        [appController.scanproductsaveimage addObject:data];
//        [self compare];
//        [self stopScanning];
//
//    }
//    else if ([codeString isEqualToString:@"0836722005159"] && flag==NO) {
//        flag=YES;
//        UIImage* tempImage = [[UIImage alloc] init];
//        tempImage = [UIImage imageNamed:@"fubar2_grande.png"];
//        NSData *data = UIImagePNGRepresentation(tempImage);
//        productImageData = [ commonUtils encodeToBase64String:tempImage byCompressionRatio:0.5];
//        [appController.scanproductsaveimage addObject:data];
//        [self compare];
//        [self stopScanning];
//
//    }
//    else if ([codeString isEqualToString:@"0836722005173"] && flag==NO) {
//        flag=YES;
//        UIImage* tempImage = [[UIImage alloc] init];
//        tempImage = [UIImage imageNamed:@"md_grande.jpg"];
//        NSData *data = UIImagePNGRepresentation(tempImage);
//        productImageData = [ commonUtils encodeToBase64String:tempImage byCompressionRatio:0.5];
//        [appController.scanproductsaveimage addObject:data];
//        [self compare];
//        [self stopScanning];
//
//    }
//    else if (([codeString isEqualToString:@"0836722005319"]||[codeString isEqualToString:@"0836722005289"]||[codeString isEqualToString:@"0836722005142"]) && flag==NO) {
//        flag=YES;
//        UIImage* tempImage = [[UIImage alloc] init];
//        tempImage = [UIImage imageNamed:@"pk_516ecc60-1e98-4173-8930-f8ec711994f2_grande.jpg"];
//        NSData *data = UIImagePNGRepresentation(tempImage);
//        productImageData = [ commonUtils encodeToBase64String:tempImage byCompressionRatio:0.5];
//        [appController.scanproductsaveimage addObject:data];
//        [self compare];
//        [self stopScanning];
//
//    }
//    else if(flag==NO){
//        
//        NSString *msg=@"Sorry!!! This prouduct don't exist on our server.";
//        [commonUtils showVAlertSimple:@"Alert!!!" body:msg duration:2.0];
//       
//        
//    }
    
    
    
    // Add constraints to label to improve text size?
    
    // Add the label to the view
    [view addSubview:label];
    
    return view;
}

- (void)stopScanning {
    
    self.previewView.hidden=YES;
    self.viewOfInterest.hidden=YES;
    
    [self.scanner stopScanning];
    
    [self.toggleScanningButton setTitle:@"BARCODE SCAN" forState:UIControlStateNormal];
    self.toggleScanningButton.backgroundColor = self.view.tintColor;
    
    for (NSString *code in self.overlayViews.allKeys) {
        [self.overlayViews[code] removeFromSuperview];
    }
}
//-(void)compare{
//    
//    if (![_barcodenumber.text isEqualToString:@""] && productImageData != nil) {
//        
//        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
//        [paramDic setObject:_barcodenumber.text forKey:@"product_barcode"];
//        [paramDic setObject:productImageData forKey:@"product_image"];
//        if(appController.signflag){
//        [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"product_user_id"];
//        }
//        else{
//        [paramDic setObject:[appController.currentUser objectForKey:@"user_facebook_id"] forKey:@"product_user_id"];
//        }
//        [self requestAPI:paramDic];
//    }
//}
#pragma mark - API - fetchproduct
- (void)requestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData:) toTarget:self withObject:dic];
}

- (void)requestData:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_PRODUCT_FETCH_INFO withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.productinfo = [result objectForKey:@"product_info"];
            NSLog(@"%@", appController.productinfo);

 //           [commonUtils setUserDefaultDic:@"all_products" withDic:appController.productinfo];
            
            NSString *strClientPhoto = [appController.productinfo objectForKey:@"product_image"];
            NSString *imageUrl = [NSString stringWithFormat: @"%@%@", MEDIA_URL, strClientPhoto];
            
    //       [commonUtils setImageViewAFNetworking:imageView withImageUrl:imageUrl withPlaceholderImage:nil];
            
            [appController.tempproductsaveimage5 addObject:imageUrl];
            [appController.tempproductname5 addObject:[appController.productinfo objectForKey:@"product_name"]];
            [appController.tempproductprice5 addObject:[appController.productinfo objectForKey:@"product_price"]];
            [appController.tempproductflavor5 addObject:[appController.productinfo objectForKey:@"product_flavor"]];
            [appController.tempproductweight5 addObject:[appController.productinfo objectForKey:@"product_weight"]];
            [appController.tempproductdescription5 addObject:[appController.productinfo objectForKey:@"product_des"]];
            
            
            appController.scanproductsaveimage=appController.tempproductsaveimage5;
            appController.scanproductname=appController.tempproductname5;
            appController.scanproductprice=appController.tempproductprice5;
            appController.scanproductflavor=appController.tempproductflavor5;
            appController.scanproductweight=appController.tempproductweight5 ;
            appController.scanproductdescription=appController.tempproductdescription5;           
            
            
          
            NSLog(@"%@", appController.productinfo);
            
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




-(void) requestOver {
    
    featureViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"featureView"];
    [self.navigationController pushViewController:panelController animated:YES];
}


#pragma mark - Actions

- (IBAction)toggleScanningTapped:(id)sender {
    
    if ([self.scanner isScanning]) {
        [self stopScanning];
    } else {
        [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
            if (success) {
                
                [self startScanning];
                
            } else {
                [self displayPermissionMissingAlert];
            }
        }];
    }
    
}

- (IBAction)switchCameraTapped:(id)sender {
    [self.scanner flipCamera];
}

- (void)backTapped {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Notifications

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    self.scanner.scanRect = self.viewOfInterest.frame;
}

#pragma mark - Helper Methods

- (void)displayPermissionMissingAlert {
    NSString *message = nil;
    if ([MTBBarcodeScanner scanningIsProhibited]) {
        message = @"This app does not have permission to use the camera.";
    } else if (![MTBBarcodeScanner cameraIsPresent]) {
        message = @"This device does not have a camera.";
    } else {
        message = @"An unknown error occurred.";
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Scanning Unavailable"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}
@end

