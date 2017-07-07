//
//  NewProductViewCell.m
//  Virtual Store
//
//  Created by Jose on 4/15/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "NewProductViewCell.h"

@implementation NewProductViewCell

-(void)setNewproductInfo:(NSDictionary *)newproductInfo{
    
    [commonUtils setRoundedRectBorderImage:_newproductimage withBorderWidth:3 withBorderColor:[UIColor redColor] withBorderRadius:15];
    
    _newproductname.text=newproductInfo[@"product_name"];
    _newproductprice.text=newproductInfo[@"product_price"];
    
    NSString *strClientPhoto = newproductInfo[@"product_image"];
    NSString *imageUrl = [NSString stringWithFormat: @"%@%@", MEDIA_URL, strClientPhoto];
    [commonUtils setImageViewAFNetworking:_newproductimage withImageUrl:imageUrl withPlaceholderImage:nil];
   
    
    [appController.tempproductsaveimage3 addObject:imageUrl];
    [appController.tempproductname3 addObject:newproductInfo[@"product_name"]];
    [appController.tempproductprice3 addObject:newproductInfo[@"product_price"]];
    [appController.tempproductflavor3 addObject:newproductInfo[@"product_flavor"]];
    [appController.tempproductweight3 addObject:newproductInfo[@"product_weight"]];
    [appController.tempproductdescription3 addObject:newproductInfo[@"product_des"]];
    
    
    appController.scanproductsaveimage=appController.tempproductsaveimage3;
    appController.scanproductname=appController.tempproductname3;
    appController.scanproductprice=appController.tempproductprice3;
    appController.scanproductflavor=appController.tempproductflavor3;
    appController.scanproductweight=appController.tempproductweight3 ;
    appController.scanproductdescription=appController.tempproductdescription3;
    
    }
@end
