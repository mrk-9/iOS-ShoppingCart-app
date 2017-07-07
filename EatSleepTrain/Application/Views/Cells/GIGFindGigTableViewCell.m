//
//  GIGFindGigTableViewCell.m
//  Gig
//
//  Created by New Star on 1/27/16.
//  Copyright © 2016 NewMobileStar. All rights reserved.
//

#import "GIGFindGigTableViewCell.h"

@implementation GIGFindGigTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self initUI];
    [self initView];
    
    [_starView addSubview:_clientRatingView];
   
}

- (void) initUI{
    
    [commonUtils setRoundedRectBorderImage:_gigPhotoImageView withBorderWidth:1.0f withBorderColor:appController.appMainColor withBorderRadius:5.0f];
    
    [commonUtils cropCircleImage:_clientPhotoView];
    
    [commonUtils setRoundedRectView:_gigPayAmountLabel withCornerRadius:2.0f];
    [commonUtils setRoundedRectView:_containerView withCornerRadius:3.0f];
    [_gigSelectedBtn setBackgroundColor:[UIColor clearColor]];
   
    
}
- (void) initView{
    
    _gigDetailTxtView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
