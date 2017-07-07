//
//  BrandProductViewCell.h
//  Virtual Store
//
//  Created by Jose on 4/15/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandProductViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *brandproductimage;
@property (weak, nonatomic) IBOutlet UILabel *brandproductname;
@property (weak, nonatomic) IBOutlet UILabel *brandproductprice;
@property (strong, nonatomic) NSDictionary* brandProductInfo;


@property (weak, nonatomic) IBOutlet UIButton *addQualityBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;

@end
