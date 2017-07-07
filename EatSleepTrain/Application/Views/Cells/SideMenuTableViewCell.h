//
//  SideMenuTableViewCell.h
//  Woof
//
//  Created by Mac on 4/5/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuTableViewCell : UITableViewCell

//@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIView *containerView;

@property (nonatomic, strong) IBOutlet UIView *inboxBadgeView;
@property (nonatomic, strong) IBOutlet UIImageView *menuIconImageView;
@property (nonatomic, strong) IBOutlet UILabel *inboxBadgeLabel;

@end