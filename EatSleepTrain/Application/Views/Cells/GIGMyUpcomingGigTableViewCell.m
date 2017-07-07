//
//  GIGMyUpcomingGigTableViewCell.m
//  Gig
//
//  Created by New Star on 1/27/16.
//  Copyright © 2016 NewMobileStar. All rights reserved.
//

#import "GIGMyUpcomingGigTableViewCell.h"

@implementation GIGMyUpcomingGigTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self initUI];
    
}

- (void) initUI{
    
    [commonUtils setRoundedRectBorderImage:_gigPhotoImageView withBorderWidth:1.0f withBorderColor:appController.appMainColor withBorderRadius:5.0f];
    
    [commonUtils setRoundedRectView:_gigPayAmountLabel withCornerRadius:2.0f];
    [commonUtils setRoundedRectView:_upcomingGigCellView withCornerRadius:6.0f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
