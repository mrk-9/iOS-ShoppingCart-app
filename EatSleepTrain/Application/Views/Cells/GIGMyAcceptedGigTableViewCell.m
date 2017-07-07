//
//  GIGMyAcceptedGigTableViewCell.m
//  Gig
//
//  Created by New Star on 1/27/16.
//  Copyright © 2016 NewMobileStar. All rights reserved.
//

#import "GIGMyAcceptedGigTableViewCell.h"


@implementation GIGMyAcceptedGigTableViewCell {
    
}

- (void)awakeFromNib {
    // Initialization code
    
    [self initUI];
    //[_starView addSubview:_starRatingView];
    
}

- (void) initUI{
    
    [commonUtils setRoundedRectBorderImage:_gigPhotoImageView withBorderWidth:1.0f withBorderColor:appController.appMainColor withBorderRadius:5.0f];
    [commonUtils setRoundedRectView:_gigPayAmountLabel withCornerRadius:2.0f];
    [commonUtils setRoundedRectView:_acceptedGigCellView withCornerRadius:6.0f];
    
    [commonUtils cropCircleImage:_workerProfileImageView];
    
//    [commonUtils setRoundedRectBorderImage:_workerProfileImageView withBorderWidth:1.0f withBorderColor:appController.appTextColor withBorderRadius:_workerProfileImageView.frame.size.width/2.0f];
    [_workerProfileImageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
