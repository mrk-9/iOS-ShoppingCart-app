//
//  FeaturedProductViewCell.m
//  Virtual Store
//
//  Created by Jose on 4/15/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "FeaturedProductViewCell.h"

@implementation FeaturedProductViewCell
-(void)setFeaturedProductInfo:(NSDictionary *)featuredProductInfo{
    
    [commonUtils setRoundedRectBorderImage:_featureproductimage withBorderWidth:3 withBorderColor:[UIColor redColor] withBorderRadius:15];
    _featureproductname.text=featuredProductInfo[@"product_name"];
    _featureproductprice.text=featuredProductInfo[@"product_price"];
    
    NSString *strClientPhoto = featuredProductInfo[@"product_image"];
    NSString *imageUrl = [NSString stringWithFormat: @"%@%@", MEDIA_URL, strClientPhoto];
    NSLog(@"%@",imageUrl);
    [commonUtils setImageViewAFNetworking:_featureproductimage withImageUrl:imageUrl withPlaceholderImage:nil];
   
    [appController.tempproductsaveimage1 addObject:imageUrl];
    [appController.tempproductname1 addObject:featuredProductInfo[@"product_name"]];
    [appController.tempproductprice1 addObject:featuredProductInfo[@"product_price"]];
    [appController.tempproductflavor1 addObject:featuredProductInfo[@"product_flavor"]];
    [appController.tempproductweight1 addObject:featuredProductInfo[@"product_weight"]];
    [appController.tempproductdescription1 addObject:featuredProductInfo[@"product_des"]];
    
    
    appController.scanproductsaveimage=appController.tempproductsaveimage1;
    appController.scanproductname=appController.tempproductname1;
    appController.scanproductprice=appController.tempproductprice1;
    appController.scanproductflavor=appController.tempproductflavor1;
    appController.scanproductweight=appController.tempproductweight1 ;
    appController.scanproductdescription=appController.tempproductdescription1;
    
   

    
}

@end
