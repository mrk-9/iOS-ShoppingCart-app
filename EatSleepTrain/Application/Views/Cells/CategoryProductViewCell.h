//
//  CategoryProductViewCell.h
//  Virtual Store
//
//  Created by Jose on 4/15/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryProductViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *categoryproductimage;
@property (weak, nonatomic) IBOutlet UILabel *categoryproductname;
@property (weak, nonatomic) IBOutlet UILabel *categoryproductprice;
@property (strong, nonatomic) NSDictionary* categoryProductInfo;
@property (weak, nonatomic) IBOutlet UIButton *addQualityBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;
@end
