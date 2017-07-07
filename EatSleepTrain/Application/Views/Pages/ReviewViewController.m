//
//  ReviewViewController.m
//  SCANAPP
//
//  Created by Jose on 4/29/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "ReviewViewController.h"
#import "ProductReviewCell.h"
@interface ReviewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *productimgeview;
@property (weak, nonatomic) IBOutlet UILabel *productname;
@property (weak, nonatomic) IBOutlet UICollectionView *commentview;

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentview.delegate=self;
    self.commentview.dataSource = self;

    // Do any additional setup after loading the view.
    
    [commonUtils setRoundedRectBorderImage:_productimgeview withBorderWidth:3 withBorderColor:[UIColor redColor] withBorderRadius:15];
    if(appController.flagQuality){
        
        [commonUtils setImageViewAFNetworking:_productimgeview withImageUrl:appController.scanproductsaveimage[appController.productQualityBtntag] withPlaceholderImage:nil];
        _productname.text=appController.scanproductname[appController.productQualityBtntag];
        appController.flagQuality=NO;
    }
    else{
        
        [commonUtils setImageViewAFNetworking:_productimgeview withImageUrl:appController.scanproductsaveimage[appController.indexitem] withPlaceholderImage:nil];
        _productname.text=appController.scanproductname[appController.indexitem];        

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return appController.productreviwes.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductReviewCell *cell =(ProductReviewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductReviewCell" forIndexPath:indexPath];
    cell.productReviewInfo=appController.productreviwes[indexPath.row];
    
    
    return cell;
    
}


@end
