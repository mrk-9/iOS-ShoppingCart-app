//
//  AppController.m


#import "AppController.h"

static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Utility Data
        _appMainColor = RGBA(79, 222, 178, 1.0f);
        _appTextColor = RGBA(93, 153, 219, 1.0f);
        _appThirdColor = RGBA(20, 153, 173, 1.0f);
        
        _vAlert = [[DoAlertView alloc] init];
        _vAlert.nAnimationType = 2;  // there are 5 type of animation
        _vAlert.dRound = 7.0;
        _vAlert.bDestructive = NO;  // for destructive mode
        
        
        //shopping cart item array
       
        // Fetch Product Data
          _brandproducts=[[NSMutableArray alloc] init];
          _newproducts=[[NSMutableArray alloc] init];
          _featuredproducts=[[NSMutableArray alloc] init];
          _categoryproducts=[[NSMutableArray alloc] init];
          _recentorder=[[NSMutableArray alloc] init];
          _productreviwes=[[NSMutableArray alloc] init];
        
        //Fetch Categer list
        _categorylist=[[NSMutableArray alloc] init];
        _categorylistitem=[[NSMutableArray alloc] init];
        _brandlist=[[NSMutableArray alloc] init];
        _brandlogoimage=[[NSMutableArray alloc] init];
        _brandlistitem=[[NSMutableArray alloc] init];
        
        // Recent OrderInfo & Reorder array
        _orderedproductname=[[NSMutableArray alloc] init];
        _orderedtotalprice=[[NSMutableArray alloc] init];
        _orderedproductquantity=[[NSMutableArray alloc] init];
        _orderedshipaddress=[[NSMutableArray alloc] init];
        _recentorderitem=0;
        
        // Scan Product Data
         _scanproductsaveimage=[[NSMutableArray alloc] init];
         _scanproductname=[[NSMutableArray alloc] init];
         _scanproductprice=[[NSMutableArray alloc] init];
         _scanproductflavor=[[NSMutableArray alloc] init];
         _scanproductweight=[[NSMutableArray alloc] init];
         _scanproductdescription=[[NSMutableArray alloc] init];
        
        _productQualityBtntag = -1;
        _prodcutCartBtntag = -1;
        
        
        _productimageArray=[[NSMutableArray alloc] init];
        _productnameArray=[[NSMutableArray alloc] init];
        _productpriceArray=[[NSMutableArray alloc] init];
        _productquantity=[[NSMutableArray alloc] init];
        _productimageitem=0;
        _producttotalprice=0.0;
       
        //temp array
        _tempproductname1=[[NSMutableArray alloc] init];
        _tempproductname2=[[NSMutableArray alloc] init];
        _tempproductname3=[[NSMutableArray alloc] init];
        _tempproductname4=[[NSMutableArray alloc] init];
        _tempproductname5=[[NSMutableArray alloc] init];
        
        _tempproductprice1=[[NSMutableArray alloc] init];
        _tempproductprice2=[[NSMutableArray alloc] init];
        _tempproductprice3=[[NSMutableArray alloc] init];
        _tempproductprice4=[[NSMutableArray alloc] init];
        _tempproductprice5=[[NSMutableArray alloc] init];
        
        _tempproductflavor1=[[NSMutableArray alloc] init];
        _tempproductflavor2=[[NSMutableArray alloc] init];
        _tempproductflavor3=[[NSMutableArray alloc] init];
        _tempproductflavor4=[[NSMutableArray alloc] init];
        _tempproductflavor5=[[NSMutableArray alloc] init];
        
        _tempproductweight1=[[NSMutableArray alloc] init];
        _tempproductweight2=[[NSMutableArray alloc] init];
        _tempproductweight3=[[NSMutableArray alloc] init];
        _tempproductweight4=[[NSMutableArray alloc] init];
        _tempproductweight5=[[NSMutableArray alloc] init];

        _tempproductdescription1=[[NSMutableArray alloc] init];
        _tempproductdescription2=[[NSMutableArray alloc] init];
        _tempproductdescription3=[[NSMutableArray alloc] init];
        _tempproductdescription4=[[NSMutableArray alloc] init];
        _tempproductdescription5=[[NSMutableArray alloc] init];
        
        
        _tempproductsaveimage1=[[NSMutableArray alloc] init];
        _tempproductsaveimage2=[[NSMutableArray alloc] init];
        _tempproductsaveimage3=[[NSMutableArray alloc] init];
        _tempproductsaveimage4=[[NSMutableArray alloc] init];
        _tempproductsaveimage5=[[NSMutableArray alloc] init];

        

        
        _currentUser = [[NSMutableDictionary alloc] init];
        _productinfo = [[NSMutableDictionary alloc] init];
        
        _categoryArraygender = [[NSMutableArray alloc] init];
        _provinceArray = [[NSMutableArray alloc] init];
        _countryArray = [[NSMutableArray alloc] init];
        _categoryArraygender= [@[@"Male", @"Female"] mutableCopy];
        _countryArray= [@[@"Cananda",@"US"] mutableCopy];
        _provinceArray= [@[@"AB", @"BC", @"MB", @"NB", @"NL", @"NT", @"NS", @"NU", @"ON", @"PE", @"QC", @"SK", @"YK"] mutableCopy];
        
    }
    return self;
}


+ (NSDictionary*) requestApi:(NSMutableDictionary *)params withFormat:(NSString *)url {
    return [AppController jsonHttpRequest:url jsonParam:params];
}

+ (id) jsonHttpRequest:(NSString*) urlStr jsonParam:(NSMutableDictionary *)params {
    NSString *paramStr = [commonUtils getParamStr:params];
    //NSLog(@"\n\nparameter string : \n\n%@", paramStr);
    NSData *requestData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];

    NSData *data = nil;
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSHTTPURLResponse *response = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData];
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
//    NSLog(@"\n\nresponse string : \n\n%@", responseString);
    return [[SBJsonParser new] objectWithString:responseString];
}

@end
