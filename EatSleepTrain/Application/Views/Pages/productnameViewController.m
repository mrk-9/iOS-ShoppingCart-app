//
//  productnameViewController.m
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "productnameViewController.h"
#import "ProductCell.h"
#import "shoppingcartViewController.h"
@interface productnameViewController (){
    
    NSString *price, *totalitem;
    NSInteger item;
    double sumprice,productprice;
    UIImage* imagedata;
}
@property (weak, nonatomic) IBOutlet UIImageView *productimgeview;
@property (weak, nonatomic) IBOutlet UILabel *qunatitylabel;
@property (weak, nonatomic) IBOutlet UILabel *totalprice;
@property (weak, nonatomic) IBOutlet UILabel *productname;
@property (weak, nonatomic) IBOutlet UILabel *productflavor;
@property (weak, nonatomic) IBOutlet UILabel *productweight;

@end

@implementation productnameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    item=1;
    totalitem = [NSString stringWithFormat:@"%li",(long)item];
    [commonUtils setRoundedRectBorderImage:_productimgeview withBorderWidth:3 withBorderColor:[UIColor redColor] withBorderRadius:15];
 
    if(appController.flagQuality){
        
        [commonUtils setImageViewAFNetworking:_productimgeview withImageUrl:appController.scanproductsaveimage[appController.productQualityBtntag] withPlaceholderImage:nil];
        _productname.text=appController.scanproductname[appController.productQualityBtntag];
        _productflavor.text=appController.scanproductflavor[appController.productQualityBtntag];
        _productweight.text=appController.scanproductweight[appController.productQualityBtntag];
        _totalprice.text=appController.scanproductprice[appController.productQualityBtntag];
        productprice= [_totalprice.text doubleValue];
        sumprice=productprice*item;

        
    }
    else{
        [commonUtils setImageViewAFNetworking:_productimgeview withImageUrl:appController.scanproductsaveimage[appController.indexitem] withPlaceholderImage:nil];
        
        _productname.text=appController.scanproductname[appController.indexitem];
        _productflavor.text=appController.scanproductflavor[appController.indexitem];
        _productweight.text=appController.scanproductweight[appController.indexitem];
        _totalprice.text=appController.scanproductprice[appController.indexitem];
        productprice= [_totalprice.text doubleValue];
        sumprice=productprice*item;

        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-plus and minus action
-(IBAction)plus:(id)sender{
    
    item++;
    appController.productimageitem=appController.productimageitem+1;
    sumprice=productprice*item;
    price=[NSString stringWithFormat:@"%.2f",sumprice];
    totalitem=[NSString stringWithFormat:@"%li",(long)item];
    self.qunatitylabel.text=totalitem;
    self.totalprice.text=price;
    
}
-(IBAction)minus:(id)sender{
    
    if(item>1){
    item--;
    appController.productimageitem=appController.productimageitem-1;
    sumprice=productprice*item;
    price=[NSString stringWithFormat:@"%.2f",sumprice];
    totalitem=[NSString stringWithFormat:@"%li",(long)item];
    self.qunatitylabel.text=totalitem;
    self.totalprice.text=price;
    }
    
}
- (IBAction)onclickAddCartBtn:(id)sender {
   
    [appController.productnameArray addObject:_productname.text];
    [appController.productpriceArray addObject:_totalprice.text];
    if(appController.flagQuality)
    {
       [appController.productimageArray addObject:appController.scanproductsaveimage[appController.productQualityBtntag]];
        appController.producttotalprice=appController.producttotalprice+sumprice;
        appController.flagQuality=NO;
        
    }
    else{
       [appController.productimageArray addObject:appController.scanproductsaveimage[appController.indexitem]];
        appController.producttotalprice=appController.producttotalprice+sumprice-productprice;
    }
    
    [appController.productquantity addObject:totalitem];
    
     shoppingcartViewController *productnameview = [self.storyboard instantiateViewControllerWithIdentifier:@"shoppingcartView"];
    [self.navigationController pushViewController:productnameview animated:YES];
   
    

    
    
}



@end
