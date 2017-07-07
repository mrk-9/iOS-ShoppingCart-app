//
//  RecentOrderViewController.m
//  Virtual Store
//
//  Created by Jose on 4/13/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "RecentOrderViewController.h"
#import "RecentOrderCell.h"
#import "ReOrderViewController.h"

@interface RecentOrderViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *OrderDateView;

@end

@implementation RecentOrderViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.OrderDateView.delegate=self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
   
}

#pragma mark - CollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return appController.recentorder.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RecentOrderCell *cell =(RecentOrderCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"RecentOrderCell" forIndexPath:indexPath];
    
    cell.recentOrderInfo=appController.recentorder[indexPath.row];
    cell.orderNumber.text=[NSString stringWithFormat:@"%li.",indexPath.item+1];
    
    [cell.recentOrderView setTag:indexPath.item];
    
    [cell.recentOrderView addTarget:self action:@selector(ViewEdit:) forControlEvents:UIControlEventTouchUpInside];
    
     return cell;
}


- (IBAction)ViewEdit:(UIButton*)sender {
   
    appController.recentorderitem=sender.tag;
    ReOrderViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReOrderView"];
    [self.navigationController pushViewController:panelController animated:YES];
    
}


@end
