//
//  GIGMyPostedGigTableViewCell.h
//  Gig
//
//  Created by New Star on 1/27/16.
//  Copyright © 2016 NewMobileStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIGMyPostedGigTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *gigPayAmountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gigPhotoImageView;
@property (strong, nonatomic) IBOutlet UILabel *locationAddressLabel;
@property (strong, nonatomic) IBOutlet UITextView *gigDecriptinTxtView;
@property (strong, nonatomic) IBOutlet UILabel *gigNameLabel;
@property (strong, nonatomic) IBOutlet UIView *postedGigCellView;
@property (strong, nonatomic) IBOutlet UIButton *postedGigSelectedBtn;

@end
