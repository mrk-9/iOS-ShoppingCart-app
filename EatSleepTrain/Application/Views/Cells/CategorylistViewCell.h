//
//  CategorylistViewCell.h
//  Virtual Store
//
//  Created by Jose on 4/18/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategorylistViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryname;
@property (weak, nonatomic) IBOutlet UILabel *categoryorderitem;
@property (strong, nonatomic) NSDictionary* categoryListInfo;
@end
