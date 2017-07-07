//
//  CategoryProductViewCell.m
//  Virtual Store
//
//  Created by Jose on 4/15/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "CategoryProductViewCell.h"

@implementation CategoryProductViewCell
-(void)setCategoryProductInfo:(NSDictionary *)categoryProductInfo{
    
    [commonUtils setRoundedRectBorderImage:_categoryproductimage withBorderWidth:3 withBorderColor:[UIColor redColor] withBorderRadius:15];
    
    _categoryproductname.text=categoryProductInfo[@"product_name"];
    _categoryproductprice.text=categoryProductInfo[@"product_price"];
    
    NSString *strClientPhoto = categoryProductInfo[@"product_image"];
    NSString *imageUrl = [NSString stringWithFormat: @"%@%@", MEDIA_URL, strClientPhoto];
    [commonUtils setImageViewAFNetworking:_categoryproductimage withImageUrl:imageUrl withPlaceholderImage:nil];
    
    
    [appController.tempproductsaveimage4 addObject:imageUrl];
    [appController.tempproductname4 addObject:categoryProductInfo[@"product_name"]];
    [appController.tempproductprice4 addObject:categoryProductInfo[@"product_price"]];
    [appController.tempproductflavor4 addObject:categoryProductInfo[@"product_flavor"]];
    [appController.tempproductweight4 addObject:categoryProductInfo[@"product_weight"]];
    [appController.tempproductdescription4 addObject:categoryProductInfo[@"product_des"]];
    
    
    appController.scanproductsaveimage=appController.tempproductsaveimage4;
    appController.scanproductname=appController.tempproductname4;
    appController.scanproductprice=appController.tempproductprice4;
    appController.scanproductflavor=appController.tempproductflavor4;
    appController.scanproductweight=appController.tempproductweight4 ;
    appController.scanproductdescription=appController.tempproductdescription4;    
    
}

@end
