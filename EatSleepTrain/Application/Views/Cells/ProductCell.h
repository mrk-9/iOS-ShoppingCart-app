//
//  ProductCell.h
//  EatSleepTrain
//
//  Created by Jose on 3/18/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UICollectionViewCell
//featured product view : cell image, textview
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productprice;
@property (weak, nonatomic) IBOutlet UILabel *productname;


@property (weak, nonatomic) IBOutlet UIButton *addQualityBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;


@end
