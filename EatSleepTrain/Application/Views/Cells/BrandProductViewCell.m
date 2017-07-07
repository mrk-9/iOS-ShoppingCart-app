//
//  BrandProductViewCell.m
//  Virtual Store
//
//  Created by Jose on 4/15/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "BrandProductViewCell.h"

@implementation BrandProductViewCell

-(void)setBrandProductInfo:(NSDictionary *)brandProductInfo{
   
    [commonUtils setRoundedRectBorderImage:_brandproductimage withBorderWidth:3 withBorderColor:[UIColor redColor] withBorderRadius:15];
    _brandproductname.text=brandProductInfo[@"product_name"];
    _brandproductprice.text=brandProductInfo[@"product_price"];
    
    NSString *strClientPhoto =brandProductInfo[@"product_image"];
    NSString *imageUrl = [NSString stringWithFormat: @"%@%@", MEDIA_URL, strClientPhoto];
    [commonUtils setImageViewAFNetworking:_brandproductimage withImageUrl:imageUrl withPlaceholderImage:nil];
    
    [appController.tempproductsaveimage2 addObject:imageUrl];
    [appController.tempproductname2 addObject:brandProductInfo[@"product_name"]];
    [appController.tempproductprice2 addObject:brandProductInfo[@"product_price"]];
    [appController.tempproductflavor2 addObject:brandProductInfo[@"product_flavor"]];
    [appController.tempproductweight2 addObject:brandProductInfo[@"product_weight"]];
    [appController.tempproductdescription2 addObject:brandProductInfo[@"product_des"]];
    
    
    appController.scanproductsaveimage=appController.tempproductsaveimage2;
    appController.scanproductname=appController.tempproductname2;
    appController.scanproductprice=appController.tempproductprice2;
    appController.scanproductflavor=appController.tempproductflavor2;
    appController.scanproductweight=appController.tempproductweight2 ;
    appController.scanproductdescription=appController.tempproductdescription2;
    
        
}

@end
