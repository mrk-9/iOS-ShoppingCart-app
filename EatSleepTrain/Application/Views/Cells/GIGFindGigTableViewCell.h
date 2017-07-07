//
//  GIGFindGigTableViewCell.h
//  Gig
//
//  Created by New Star on 1/27/16.
//  Copyright © 2016 NewMobileStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface GIGFindGigTableViewCell : UITableViewCell <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *gigPayAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *gigNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *gigDetailTxtView;
@property (strong, nonatomic) IBOutlet UILabel *locationAdressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gigPhotoImageView;
@property (strong, nonatomic) IBOutlet UIView *gigPhotoContainerView;
@property (strong, nonatomic) IBOutlet UIButton *gigSelectedBtn;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *clientPhotoView;
@property (strong, nonatomic) IBOutlet UILabel *ClientFirstName;

@property (strong, nonatomic) IBOutlet CWStarRateView *clientRatingView;
@property (strong, nonatomic) IBOutlet UIView *starView;

@end
