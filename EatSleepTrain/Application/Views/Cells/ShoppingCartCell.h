//
//  ShoppingCartCell.h
//  EatSleepTrain
//
//  Created by Jose on 3/19/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *shoppingCellimage;
@property (weak, nonatomic) IBOutlet UILabel *shoppingitemname;

@property (weak, nonatomic) IBOutlet UILabel *shoppingitemprice;
@property (weak, nonatomic) IBOutlet UILabel *shoppingProductItems;

@property (weak, nonatomic) IBOutlet UIButton *minus;
@property (weak, nonatomic) IBOutlet UIButton *plus;
@end
