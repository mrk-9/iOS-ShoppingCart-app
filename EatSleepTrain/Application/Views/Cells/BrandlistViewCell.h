//
//  BrandlistViewCell.h
//  Virtual Store
//
//  Created by Jose on 4/21/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandlistViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *brandname;
@property (weak, nonatomic) IBOutlet UILabel *brandorderitem;
@property (weak, nonatomic) IBOutlet UIImageView *brandlogoimage;

@property (strong, nonatomic) NSDictionary* brandListInfo;
@end
