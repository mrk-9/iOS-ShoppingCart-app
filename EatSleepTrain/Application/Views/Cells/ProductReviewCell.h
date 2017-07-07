//
//  ProductReviewCell.h
//  SCANAPP
//
//  Created by Jose on 5/3/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductReviewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UITextView *productcomments;

@property (strong, nonatomic) NSDictionary* productReviewInfo;
@end
