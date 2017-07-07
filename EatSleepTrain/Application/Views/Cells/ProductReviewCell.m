//
//  ProductReviewCell.m
//  SCANAPP
//
//  Created by Jose on 5/3/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "ProductReviewCell.h"

@implementation ProductReviewCell
-(void)setProductReviewInfo:(NSDictionary *)productReviewInfo{
    
    _username.text=productReviewInfo[@"user_name"];
    _rating.text=productReviewInfo[@"product_rating"];
    _productcomments.text=productReviewInfo[@"product_review"];
    
    
}

@end
