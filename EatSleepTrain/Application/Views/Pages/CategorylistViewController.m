//
//  CategorylistViewController.m
//  Virtual Store
//
//  Created by Jose on 4/16/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "CategorylistViewController.h"
#import "CategorylistViewCell.h"
#import "CategoryViewController.h"
@interface CategorylistViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *categorylistview;
@property (assign, nonatomic) BOOL isLoadingView;
@end

@implementation CategorylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    // Do any additional setup after loading the view.
    self.categorylistview.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return appController.categorylist.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    appController.categorytitlename=appController.categorylistitem[indexPath.item];
    
    appController.tempproductsaveimage4=[[NSMutableArray alloc] init];
    appController.tempproductname4=[[NSMutableArray alloc] init];
    appController.tempproductprice4=[[NSMutableArray alloc] init];
    appController.tempproductflavor4=[[NSMutableArray alloc] init];
    appController.tempproductweight4=[[NSMutableArray alloc] init];
    appController.tempproductdescription4=[[NSMutableArray alloc] init];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:appController.categorylistitem[indexPath.item] forKey:@"product_category"];
    [self CategoryProductrequestAPI:paramDic];
    
    
}
#pragma mark - API - fetchCategoryProduct
- (void)CategoryProductrequestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData1:) toTarget:self withObject:dic];
}

- (void)requestData1:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_CATEGORYPRODUCT_FETCH withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.categoryproducts = [result objectForKey:@"categoryProducts"];
            NSLog(@"result is =%@", result);
            NSLog(@"category is %@", appController.categoryproducts);
          
            [self performSelector:@selector(requestOver1) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
        }
        else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
    
}
-(void) requestOver1 {
    
    CategoryViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryView"];
    [self.navigationController pushViewController:panelController animated:YES];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategorylistViewCell *cell =(CategorylistViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CategorylistViewCell" forIndexPath:indexPath];
    
    cell.categoryListInfo=appController.categorylist[indexPath.row];
    
   
    return cell;
}

@end
