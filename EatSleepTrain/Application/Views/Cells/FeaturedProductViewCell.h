//
//  FeaturedProductViewCell.h
//  Virtual Store
//
//  Created by Jose on 4/15/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedProductViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *featureproductimage;
@property (weak, nonatomic) IBOutlet UILabel *featureproductname;
@property (weak, nonatomic) IBOutlet UILabel *featureproductprice;
@property (strong, nonatomic) NSDictionary* featuredProductInfo;

@property (weak, nonatomic) IBOutlet UIButton *addQualityBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;

@end
