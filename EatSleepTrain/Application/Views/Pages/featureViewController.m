//
//  featureViewController.m
//  EatSleepTrain
//
//  Created by Jose on 3/11/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "featureViewController.h"
#import "ProductCell.h"
#import "productnameViewController.h"
#import "shoppingcartViewController.h"

@interface featureViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *productcollectionview;

@end

@implementation featureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    
    self.productcollectionview.delegate=self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-action

#pragma mark - CollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return appController.scanproductsaveimage.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;{    

    
    appController.productimageitem += 1;
    
    appController.indexitem=indexPath.item;
    appController.producttotalprice= appController.producttotalprice+[appController.scanproductprice[indexPath.item] doubleValue ];
   
//    [appController.productquantity addObject:[NSString stringWithFormat:@"%li", (long)(indexPath.item+1)]];
    
    
    productnameViewController *productnameview = [self.storyboard instantiateViewControllerWithIdentifier:@"productnameView"];
    [self.navigationController pushViewController:productnameview animated:YES];

}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //cell image click event add
    
    ProductCell *cell =(ProductCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCell" forIndexPath:indexPath];

    [commonUtils setRoundedRectBorderImage:cell.productImage withBorderWidth:3 withBorderColor:[UIColor redColor] withBorderRadius:15];
    
//    UIImage * imagedate = [[UIImage alloc] initWithData:appController.scanproductsaveimage[indexPath.item]];
//    cell.productImage.image = imagedate;
    [commonUtils setImageViewAFNetworking:cell.productImage withImageUrl:appController.scanproductsaveimage[indexPath.item] withPlaceholderImage:nil];
    
    NSString *name=appController.scanproductname[indexPath.item];
    cell.productname.text=name;
    
    NSString *price=appController.scanproductprice[indexPath.item];
    cell.productprice.text=price;
    
   
    
    
    //cell button click event add
    [cell.addQualityBtn setTag:indexPath.item];
    [cell.addCartBtn setTag:indexPath.item];
    
    [cell.addQualityBtn addTarget:self action:@selector(onclickQualityBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.addCartBtn addTarget:self action:@selector(onclickCartBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(IBAction)onclickQualityBtn:(UIButton*)sender{

    appController.productQualityBtntag =sender.tag;
    appController.productimageitem += 1;
    productnameViewController *productnameview = [self.storyboard instantiateViewControllerWithIdentifier:@"productnameView"];
    [self.navigationController pushViewController:productnameview animated:YES];
    
    appController.flagQuality = YES;
    
}

-(IBAction)onclickCartBtn:(UIButton*)sender{

    appController.indexitem=sender.tag;
    appController.productimageitem += 1;
    [appController.productimageArray addObject:appController.scanproductsaveimage[sender.tag]];
    [appController.productnameArray addObject:appController.scanproductname[sender.tag]];
    [appController.productpriceArray addObject:appController.scanproductprice[sender.tag]];
//    appController.flagCart = YES;
    appController.producttotalprice= appController.producttotalprice+[appController.scanproductprice[sender.tag] doubleValue ];
    [appController.productquantity addObject:[NSString stringWithFormat:@"%li", (long)(1)]];
    
    
    shoppingcartViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"shoppingcartView"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
@end
