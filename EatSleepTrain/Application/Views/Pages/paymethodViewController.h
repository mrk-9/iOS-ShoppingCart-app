//
//  paymethodViewController.h
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "BaseViewController.h"
#import "ZZFlipsideViewController.h"
@interface paymethodViewController : BaseViewController<UITextFieldDelegate,PayPalPaymentDelegate,PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, ZZFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

@end
