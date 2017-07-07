//
//  GIGMyAcceptedGigTableViewCell.h
//  Gig
//
//  Created by New Star on 1/27/16.
//  Copyright © 2016 NewMobileStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface GIGMyAcceptedGigTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *gigPhotoImageView;
@property (strong, nonatomic) IBOutlet UILabel *gigWorkerNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *gigDescriptionTxtView;
@property (strong, nonatomic) IBOutlet UILabel *gigNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *gigPayAmountLabel;



@property (strong, nonatomic) IBOutlet UIButton *gigSelectedBtn;
@property (strong, nonatomic) IBOutlet UIImageView *workerProfileImageView;

@property (strong, nonatomic) IBOutlet UIView *acceptedGigCellView;

@property (strong, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) IBOutlet UIView *starRatingView;

@end
