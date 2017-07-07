//
//  BrandlistViewCell.m
//  Virtual Store
//
//  Created by Jose on 4/21/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "BrandlistViewCell.h"

@implementation BrandlistViewCell
-(void)setBrandListInfo:(NSDictionary *)brandListInfo{
   
   
 
    NSString *strClientPhoto = brandListInfo[@"brand_logo"];
    NSString *imageUrl = [NSString stringWithFormat: @"%@%@", MEDIA_URL, strClientPhoto];
    [commonUtils setImageViewAFNetworking:_brandlogoimage withImageUrl:imageUrl withPlaceholderImage:nil];
   
    [appController.brandlogoimage addObject:brandListInfo[@"brand_logo"]];

   // _brandname.text=brandListInfo[@"product_brand"];
    [appController.brandlistitem addObject:brandListInfo[@"product_brand"]];

}

@end
