//
//  CategoryViewController.m
//  Virtual Store
//
//  Created by Jose on 4/15/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryProductViewCell.h"
#import "productnameViewController.h"
#import "shoppingcartViewController.h"

@interface CategoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *categoryView;
@property (weak, nonatomic) IBOutlet UILabel *categorytitle;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.categoryView.delegate=self;
    self.categoryView.dataSource=self;
    _categorytitle.text=appController.categorytitlename;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return appController.categoryproducts.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    appController.productimageitem += 1;
    appController.indexitem=indexPath.item;
    appController.producttotalprice= appController.producttotalprice+[appController.scanproductprice[indexPath.item] doubleValue ];
    
    productnameViewController *productnameview = [self.storyboard instantiateViewControllerWithIdentifier:@"productnameView"];
    [self.navigationController pushViewController:productnameview animated:YES];
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryProductViewCell *cell =(CategoryProductViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryProductViewCell" forIndexPath:indexPath];
    
    cell.categoryProductInfo  =appController.categoryproducts[indexPath.row];
    
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
    
    appController.producttotalprice= appController.producttotalprice+[appController.scanproductprice[sender.tag] doubleValue ];
    [appController.productquantity addObject:[NSString stringWithFormat:@"%li", (long)(1)]];
    shoppingcartViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"shoppingcartView"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
