//
//  RecentOrderCell.h
//  Virtual Store
//
//  Created by Jose on 4/14/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentOrderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderdate;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (strong, nonatomic) NSDictionary* recentOrderInfo;

@property (weak, nonatomic) IBOutlet UIButton *recentOrderView;

@end
