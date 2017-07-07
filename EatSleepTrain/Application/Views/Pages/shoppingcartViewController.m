//
//  shoppingcartViewController.m
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "shoppingcartViewController.h"
#import "ShoppingCartCell.h"
@interface shoppingcartViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>{
   
    double productitemprice;
    NSInteger item;
    NSString *item1;
}
    

@property (weak, nonatomic) IBOutlet UILabel *totalshoppingitem;
@property (weak, nonatomic) IBOutlet UILabel *carttotalprice;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)checkOut:(id)sender;


@end

@implementation shoppingcartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate=self;
    item=0;
    productitemprice=0.0;
    
    item1=[NSString stringWithFormat:@"%li", (long)(appController.productimageitem)];
    _totalshoppingitem.text=item1;
    NSString *price=[NSString stringWithFormat:@"$%.2f", appController.producttotalprice];
    _carttotalprice.text=price;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return appController.productimageArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ShoppingCartCell *cell=(ShoppingCartCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ShoppingCartCell" forIndexPath:indexPath];
    
    [commonUtils setRoundedRectBorderImage:cell.shoppingCellimage withBorderWidth:2 withBorderColor:[UIColor redColor] withBorderRadius:5];
    
    [commonUtils setImageViewAFNetworking:cell.shoppingCellimage withImageUrl:appController.productimageArray[indexPath.item] withPlaceholderImage:nil];
    cell.shoppingitemname.text=appController.productnameArray[indexPath.item];
    cell.shoppingitemprice.text=appController.productpriceArray[indexPath.item];
    cell.shoppingProductItems.text=appController.productquantity[indexPath.item];
    
    
    //cell button click event add
    [cell.minus setTag:indexPath.item];
    [cell.plus setTag:indexPath.item];
    
    [cell.minus addTarget:self action:@selector(onclickMinus:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.plus addTarget:self action:@selector(onclickPlus:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(IBAction)onclickMinus:(UIButton*)sender{
    
     item=[appController.productquantity[sender.tag] integerValue];

    if(item>1)
    {
        item--;
        
        appController.productimageitem=appController.productimageitem-1;
        item1=[NSString stringWithFormat:@"%li", (long)(appController.productimageitem)];
        _totalshoppingitem.text=item1;
        
        [appController.productquantity replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%li", item]];
        
        if(appController.flagQuality){
            
            productitemprice=[appController.productpriceArray[sender.tag] doubleValue]-[appController.scanproductprice[appController.productQualityBtntag] doubleValue];
            [appController.productpriceArray replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%.2f", productitemprice]];
            
            appController.producttotalprice=appController.producttotalprice-[appController.scanproductprice[appController.productQualityBtntag] doubleValue];
        }
        else{
            
            productitemprice=[appController.productpriceArray[sender.tag] doubleValue]-[appController.scanproductprice[appController.indexitem] doubleValue];
            [appController.productpriceArray replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%.2f", productitemprice]];
            
            appController.producttotalprice=appController.producttotalprice-[appController.scanproductprice[appController.indexitem] doubleValue];
        }
        
      
        NSString *price=[NSString stringWithFormat:@"$%.2f", appController.producttotalprice];
         _carttotalprice.text=price;
        
        [_collectionView reloadData];

    }
    
}

-(IBAction)onclickPlus:(UIButton*)sender{
    
    
        item=[appController.productquantity[sender.tag] integerValue];
    
    
        item++;
        appController.productimageitem=appController.productimageitem+1;
        item1=[NSString stringWithFormat:@"%li", (long)(appController.productimageitem)];
        _totalshoppingitem.text=item1;
    
       [appController.productquantity replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%li", item]];
    
       if(appController.flagQuality){
        
           productitemprice=[appController.productpriceArray[sender.tag] doubleValue]+[appController.scanproductprice[appController.productQualityBtntag] doubleValue];
           [appController.productpriceArray replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%.2f", productitemprice]];
           
           appController.producttotalprice=appController.producttotalprice+[appController.scanproductprice[appController.productQualityBtntag] doubleValue];
       }
    
       else{
           
           productitemprice=[appController.productpriceArray[sender.tag] doubleValue]+[appController.scanproductprice[appController.indexitem] doubleValue];
           [appController.productpriceArray replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%.2f", productitemprice]];
           appController.producttotalprice=appController.producttotalprice+[appController.scanproductprice[appController.indexitem] doubleValue];
       }
        
    
        NSString *price=[NSString stringWithFormat:@"$%.2f", appController.producttotalprice];
        _carttotalprice.text=price;
        
        [_collectionView reloadData];
        
    
   
    
}

- (IBAction)checkOut:(id)sender {

    
}
@end
