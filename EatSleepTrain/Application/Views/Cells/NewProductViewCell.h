//
//  NewProductViewCell.h
//  Virtual Store
//
//  Created by Jose on 4/15/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewProductViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newproductimage;
@property (weak, nonatomic) IBOutlet UILabel *newproductname;
@property (weak, nonatomic) IBOutlet UILabel *newproductprice;
@property (strong, nonatomic) NSDictionary* newproductInfo;

@property (weak, nonatomic) IBOutlet UIButton *addQualityBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;

@end
