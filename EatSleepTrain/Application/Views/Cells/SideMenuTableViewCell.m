//
//  SideMenuTableViewCell.m
//  Woof
//
//  Created by Mac on 4/5/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import "SideMenuTableViewCell.h"

@implementation SideMenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [commonUtils setRoundedRectView:_inboxBadgeView withCornerRadius:3.0f];
    //_titleLabel.textColor = [UIColor grayColor];
    
    //[commonUtils cropCircleView:self.inboxBadgeView];
    //[commonUtils cropCircleImage:self.inboxBadgeBackgroundImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
