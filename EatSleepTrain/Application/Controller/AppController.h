//  AppController.h
//  Created by BE

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppController : NSObject

@property (nonatomic, strong) NSMutableDictionary *currentUser, *apnsMessage, *productinfo;

// Temporary Variables

@property (nonatomic, strong) NSString *menuPhotoTag, *facebookPhotoUrlTemp, *workerAcceptPayAmount, *signUpMode, *gender;
@property (nonatomic, strong) NSMutableArray *menuPages, *allGig, *allMyGig, *allPosters;
@property (nonatomic, strong) UIImage *currentUserPhoto;
@property (nonatomic, assign) BOOL isMyProfileChanged;

// Utility Variables
@property (nonatomic, strong) UIColor *appMainColor, *appTextColor, *appThirdColor;
@property (nonatomic, strong) DoAlertView *vAlert;

// My Variables
@property (nonatomic, strong) NSMutableArray *categoryArraygender,*provinceArray,*countryArray;
@property (nonatomic, strong) NSMutableArray *categoryArrayage;
//shopping cart item array




//scan product Array
@property (nonatomic, strong) NSMutableArray *scanproductsaveimage;
@property (nonatomic, strong) NSMutableArray *scanproductname;
@property (nonatomic, strong) NSMutableArray *scanproductprice;
@property (nonatomic, strong) NSMutableArray *scanproductweight;
@property (nonatomic, strong) NSMutableArray *scanproductflavor;
@property (nonatomic, strong) NSMutableArray *scanproductdescription;

@property (nonatomic, assign) NSInteger productQualityBtntag;
@property (nonatomic, assign) BOOL flagQuality;

@property (nonatomic, assign) NSInteger prodcutCartBtntag;

// Fetch Product Array
@property (nonatomic, strong) NSMutableArray *productreviwes;
@property (nonatomic, strong) NSMutableArray *brandproducts;
@property (nonatomic, strong) NSMutableArray *newproducts;
@property (nonatomic, strong) NSMutableArray *featuredproducts;
@property (nonatomic, strong) NSMutableArray *categoryproducts;
@property (nonatomic, strong) NSString *categorytitlename;
@property (nonatomic, strong) NSString *brandtitlename;
@property (nonatomic, strong) NSMutableArray *recentorder;
// Fetch Category Brand list Array
@property (nonatomic, strong) NSMutableArray *categorylist;
@property (nonatomic, strong) NSMutableArray *categorylistitem;
@property (nonatomic, strong) NSMutableArray *brandlist;
@property (nonatomic, strong) NSMutableArray *brandlogoimage;
@property (nonatomic, strong) NSMutableArray *brandlistitem;

//tem array
@property (nonatomic, strong) NSMutableArray *tempproductsaveimage1;
@property (nonatomic, strong) NSMutableArray *tempproductname1;
@property (nonatomic, strong) NSMutableArray *tempproductprice1;
@property (nonatomic, strong) NSMutableArray *tempproductweight1;
@property (nonatomic, strong) NSMutableArray *tempproductflavor1;
@property (nonatomic, strong) NSMutableArray *tempproductdescription1;


@property (nonatomic, strong) NSMutableArray *tempproductsaveimage2;
@property (nonatomic, strong) NSMutableArray *tempproductname2;
@property (nonatomic, strong) NSMutableArray *tempproductprice2;
@property (nonatomic, strong) NSMutableArray *tempproductweight2;
@property (nonatomic, strong) NSMutableArray *tempproductflavor2;
@property (nonatomic, strong) NSMutableArray *tempproductdescription2;

@property (nonatomic, strong) NSMutableArray *tempproductsaveimage3;
@property (nonatomic, strong) NSMutableArray *tempproductname3;
@property (nonatomic, strong) NSMutableArray *tempproductprice3;
@property (nonatomic, strong) NSMutableArray *tempproductweight3;
@property (nonatomic, strong) NSMutableArray *tempproductflavor3;
@property (nonatomic, strong) NSMutableArray *tempproductdescription3;

@property (nonatomic, strong) NSMutableArray *tempproductsaveimage4;
@property (nonatomic, strong) NSMutableArray *tempproductname4;
@property (nonatomic, strong) NSMutableArray *tempproductprice4;
@property (nonatomic, strong) NSMutableArray *tempproductweight4;
@property (nonatomic, strong) NSMutableArray *tempproductflavor4;
@property (nonatomic, strong) NSMutableArray *tempproductdescription4;

@property (nonatomic, strong) NSMutableArray *tempproductsaveimage5;
@property (nonatomic, strong) NSMutableArray *tempproductname5;
@property (nonatomic, strong) NSMutableArray *tempproductprice5;
@property (nonatomic, strong) NSMutableArray *tempproductweight5;
@property (nonatomic, strong) NSMutableArray *tempproductflavor5;
@property (nonatomic, strong) NSMutableArray *tempproductdescription5;




// Recent Order & Reorder Array
@property (nonatomic, strong) NSMutableArray *orderedproductname;
@property (nonatomic, strong) NSMutableArray *orderedshipaddress;
@property (nonatomic, strong) NSMutableArray *orderedproductquantity;
@property (nonatomic, strong) NSMutableArray *orderedtotalprice;
@property (nonatomic, assign) NSInteger recentorderitem;

//@property (nonatomic, assign) BOOL flagCart;

@property (nonatomic, assign) NSInteger productimageitem,indexitem;
@property (nonatomic, assign) double producttotalprice;
@property (nonatomic, strong) NSMutableArray* productquantity;
@property (nonatomic, strong) NSMutableArray* productimageArray;
@property (nonatomic, strong) NSMutableArray* productpriceArray;
@property (nonatomic, strong) NSMutableArray* productnameArray;
//checkout variables
@property (nonatomic, strong) NSString *address,*country,*phonenumber,*postalcode,*city,*province;
//sign data
@property (nonatomic, strong) NSString *firstname,*lastname,*email,*password;
@property (nonatomic, assign) BOOL signflag;

//user info data

@property (nonatomic, strong) NSString *userinfoaddress;
@property (nonatomic, strong) NSString *userinfocountry;
@property (nonatomic, strong) NSString *userinfocity;
@property (nonatomic, strong) NSString *userinfoprovince;
@property (nonatomic, strong) NSString *userinfopostalcode;
@property (nonatomic, strong) NSString *userinfophonenumber;
+ (AppController *)sharedInstance;

@end