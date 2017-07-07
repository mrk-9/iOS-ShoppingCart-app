//
//  BrandlistViewController.m
//  Virtual Store
//
//  Created by Jose on 4/21/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "BrandlistViewController.h"
#import "BrandlistViewCell.h"
#import "BrandViewController.h"

@interface BrandlistViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *brandlistview;
@property (assign, nonatomic) BOOL isLoadingView;
@end

@implementation BrandlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    self.brandlistview.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return appController.brandlist.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    appController.brandtitlename=appController.brandlistitem[indexPath.item];
    
    appController.tempproductsaveimage2=[[NSMutableArray alloc] init];
    appController.tempproductname2=[[NSMutableArray alloc] init];
    appController.tempproductprice2=[[NSMutableArray alloc] init];
    appController.tempproductflavor2=[[NSMutableArray alloc] init];
    appController.tempproductweight2=[[NSMutableArray alloc] init];
    appController.tempproductdescription2=[[NSMutableArray alloc] init];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:appController.brandlistitem[indexPath.item] forKey:@"product_brand"];
    [self FetchBrandProductrequestAPI:paramDic];
    
    
}
#pragma mark - API - fetchCategoryProduct
- (void)FetchBrandProductrequestAPI:(NSMutableDictionary *)dic {
    self.isLoadingView = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData1:) toTarget:self withObject:dic];
}

- (void)requestData1:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_BRANDPRODUCT_FETCH withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];
    self.isLoadingView = NO;
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.brandproducts = [result objectForKey:@"brandProducts"];
            
            NSLog(@"result is === %@",result);
            
            NSLog(@" memo  is %@", appController.brandproducts);
            
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
    
    BrandViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"BrandView"];
    [self.navigationController pushViewController:panelController animated:YES];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BrandlistViewCell *cell =(BrandlistViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"BrandlistViewCell" forIndexPath:indexPath];
    
    cell.brandListInfo=appController.brandlist[indexPath.row];
   
    return cell;
}

@end