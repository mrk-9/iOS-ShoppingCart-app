//
//  RecentOrderCell.m
//  Virtual Store
//
//  Created by Jose on 4/14/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "RecentOrderCell.h"

@implementation RecentOrderCell
-(void)setRecentOrderInfo:(NSDictionary *)recentOrderInfo{
    
    _orderdate.text=recentOrderInfo[@"order_date"];
    
    [appController.orderedproductname addObject:recentOrderInfo[@"order_product_name"]];
    [appController.orderedproductquantity addObject:recentOrderInfo[@"order_product_quantity"]];
    [appController.orderedtotalprice addObject:recentOrderInfo[@"order_total_price"]]; 
    [appController.orderedshipaddress addObject:recentOrderInfo[@"order_ship_address"]];
    
}

@end
