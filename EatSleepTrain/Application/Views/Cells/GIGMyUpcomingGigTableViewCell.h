//
//  GIGMyUpcomingGigTableViewCell.h
//  Gig
//
//  Created by New Star on 1/27/16.
//  Copyright © 2016 NewMobileStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIGMyUpcomingGigTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *gigPayAmountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gigPhotoImageView;
@property (strong, nonatomic) IBOutlet UILabel *gigClientNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *gigDescriptionTxtView;
@property (strong, nonatomic) IBOutlet UILabel *gigNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *upcomingGigSelectedBtn;

@property (strong, nonatomic) IBOutlet UIView *upcomingGigCellView;

@end
