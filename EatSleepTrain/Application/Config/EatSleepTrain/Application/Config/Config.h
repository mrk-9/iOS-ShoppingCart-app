//
//  Config.m

//#define SERVER_URL @"http://172.16.1.180:8080/eatsleep"

#define SERVER_URL @"http://admin.scanapp.net"

#define API_KEY @"123456"

#define API_URL (SERVER_URL @"/api")


#define API_URL_USER_SIGNUP (SERVER_URL @"/api/user_signup")
#define API_URL_USER_SIGNIN (SERVER_URL @"/api/user_login")
#define API_URL_USER_RETRIEVE_PASSWORD (SERVER_URL @"/api/user_retrieve_password")
#define API_USER_CHANGE_PASSWORD (SERVER_URL @"/api/user_change_password")

#define API_PRODUCT_FETCH_INFO (SERVER_URL @"/api/fetchproductinformation")
#define API_ORDERINFO_REGISTER (SERVER_URL @"/api/registerOrderInformation")
#define API_PRODUCT_REGISTER (SERVER_URL @"/api/uploadproduct")
#define API_PRODUCT_REVIEW_REGISTER (SERVER_URL @"/api/registerProductReview")
#define API_PRODUCT_REVIEWS_FETCH (SERVER_URL @"/api/fetchProductReviews")
#define API_SHIPPINGADRESS_REGISTER (SERVER_URL @"/api/registerShippingInformation")

#define API_FEATUREDPRODUCT_FETCH (SERVER_URL @"/api/fetchFeaturedProducts")
#define API_CATEGORYPRODUCT_FETCH (SERVER_URL @"/api/fetchCategoryProducts")
#define API_CATEGORYLIST_FETCH (SERVER_URL @"/api/fetchCategoryList")
#define API_BRANDPRODUCT_FETCH (SERVER_URL @"/api/fetchBrandProducts")
#define API_BRANDLIST_FETCH (SERVER_URL @"/api/fetchBrandList")
#define API_NEWPRODUCT_FETCH (SERVER_URL @"/api/fetchNewProducts")
#define API_ORDERINFO_FETCH (SERVER_URL @"/api/fetchOrderInformation")

// MEDIA CONFIG
#define MEDIA_URL (SERVER_URL @"/images/products/")
#define MEDIA_URL_USERS (SERVER_URL @"/images/users/")



// Settings Config


// Utility Values
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
#define M_PI        3.14159265358979323846264338327950288

#define FONT_MONTSERRAT_REGULAR(s) [UIFont fontWithName:@"Montserrat-Regular" size:s]
#define FONT_MONTSERRAT_BOLD(s) [UIFont fontWithName:@"Montserrat-Bold" size:s]
#define FONT_GOTHAM_NORMAL(s) [UIFont fontWithName:@"GothamRounded-Book" size:s]
#define FONT_GOTHAM_BOLD(s) [UIFont fontWithName:@"GothamRounded-Bold" size:s]

// Phone Versions
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_ABOVE (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0)
