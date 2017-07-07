//
//  CategorylistViewCell.m
//  Virtual Store
//
//  Created by Jose on 4/18/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "CategorylistViewCell.h"

@implementation CategorylistViewCell
-(void)setCategoryListInfo:(NSDictionary *)categoryListInfo{
    
        
    _categoryname.text=categoryListInfo[@"product_category"];    
    [appController.categorylistitem addObject:categoryListInfo[@"product_category"]];
}

@end
