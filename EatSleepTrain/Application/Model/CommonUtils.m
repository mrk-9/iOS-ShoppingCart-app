//
//  CommonUtils.m
//


#import "CommonUtils.h"
#import "NSString+Base64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CommonUtils

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


- (void)showAlert:(NSString *)title withMessage:(NSString *)message {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
}

- (void)showVAlertSimple:(NSString *)title body:(NSString *)body duration:(float)duration {
    _dicAlertContent = [[NSMutableDictionary alloc] init];
    [_dicAlertContent setObject:title forKey:@"title"];
    [_dicAlertContent setObject:body forKey:@"body"];
    [_dicAlertContent setObject:[NSString stringWithFormat:@"%f", duration] forKey:@"duration"];
    
    [self performSelector:@selector(vAlertSimpleThread) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}

-(void)vAlertSimpleThread {
    
    appController.vAlert = [[DoAlertView alloc] init];
    appController.vAlert.nAnimationType = 2;  // there are 5 type of animation
    appController.vAlert.dRound = 7.0;
    appController.vAlert.bDestructive = NO;
    
    [appController.vAlert doAlert:[_dicAlertContent objectForKey:@"title"] body:[_dicAlertContent objectForKey:@"body"] duration:[[_dicAlertContent objectForKey:@"duration"] floatValue] done:^(DoAlertView *alertView) {}];
}



- (void) removeAllSubViews:(UIView *) view {
    for (long i=view.subviews.count-1; i>=0; i--) {
        [[view.subviews objectAtIndex:i] removeFromSuperview];
    }
}
- (void)setScrollViewOffsetBottom:(UIScrollView *) view {
    CGPoint bottomOffset = CGPointMake(0, view.contentSize.height - view.bounds.size.height);
    [view setContentOffset:bottomOffset animated:YES];
}

- (BOOL)checkKeyInDic:(NSString *)key inDic:(NSMutableDictionary *)dic {
    BOOL success = NO;
    id obj = dic[key];
    if ( obj != nil ) {
        if ( obj != (id)[NSNull null] ) {
            success = YES;
        }
        else {
            NSLog(@"Warning! %@ section is empty.", key);
        }
    }
    //    else {
    //        NSLog(@"Warning! %@ section is not found.", key);
    //    }
    
    return success;
}
- (NSString *)getValueByIdFromArray:(NSMutableArray *)arr idKeyFormat:(NSString *)keyIdStr valKeyFormat:(NSString *)keyValStr idValue:(NSString *)idStr {
    NSString *val = @"";
    for(NSMutableDictionary *dic in arr) {
        if([[dic objectForKey:keyIdStr] isEqualToString:idStr]) {
            val = [dic objectForKey:keyValStr];
            break;
        }
    }
    return val;
}
- (NSMutableArray *) getContentArrayFromIdsString:(NSString *)idsString withSeparator:(NSString *)separator withContentSource:(NSMutableArray *)sourceArray {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSArray *idsArr = [idsString componentsSeparatedByString:separator];
    for(NSString *idStr in idsArr) {
        if(![idStr isEqualToString:@""] && [self checkStringNumeric:idStr]) {
            [arr addObject:[self getValueByIdFromArray:sourceArray idKeyFormat:@"id" valKeyFormat:@"name" idValue:idStr]];
        }
    }
    return arr;
}

- (id)getUserDefault:(NSString *)key {
    id val = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    //    if([val isKindOfClass:[NSMutableArray class]] && val == nil) return @"";
    if([val isKindOfClass:[NSString class]] && (val == nil || val == NULL || [val isEqualToString:@"0"])) val = nil;
    return val;
}
- (void)setUserDefault:(NSString *)key withFormat:(id)val {
    if([val isKindOfClass:[NSString class]] && [val isEqualToString:@""]) val = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
}
- (void)removeUserDefault:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (NSMutableDictionary *)getUserDefaultDicByKey:(NSString *)key {
    NSMutableDictionary *dicAll = (NSMutableDictionary *)[[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for(NSString *dicKey in [dicAll allKeys]) {
        if([dicKey rangeOfString:[key stringByAppendingString:@"_"]].location != NSNotFound) {
            [dic setObject:[dicAll objectForKey:dicKey] forKey:[dicKey substringFromIndex:[[key stringByAppendingString:@"_"] length]]];
        }
    }
    return dic;
}
- (void)setUserDefaultDic:(NSString *)key withDic:(NSMutableDictionary *)dic {
    NSString *newKey = @"";
    for(NSString *dicKey in [dic allKeys]) {
        //if(![[dic objectForKey:dicKey] isKindOfClass:[NSMutableArray class]]) {
        newKey = [[key stringByAppendingString:@"_"] stringByAppendingString:dicKey];
        [self setUserDefault:newKey withFormat:[dic objectForKey:dicKey]];
        //}
    }
}
- (void)removeUserDefaultDic:(NSString *)key {
    NSMutableDictionary *dicAll = (NSMutableDictionary *)[[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for(NSString *dicKey in [dicAll allKeys]) {
        if([dicKey rangeOfString:[key stringByAppendingString:@"_"]].location != NSNotFound) {
            [self removeUserDefault:dicKey];
        }
    }
}

- (NSUInteger)isUserLoggedIn {
    if([commonUtils getUserDefault:@"current_user_user_id"] != nil) {
        appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
        return [[appController.currentUser objectForKey:@"user_type"] isEqualToString:@"parent"] ? 1 : 2;
    } else {
        return 0;
    }
}
- (NSString *)getBlankString:(NSString *)str {
    if([str isEqualToString:@"0"]) {
        return @"";
    } else {
        return str;
    }
}
- (int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

- (NSMutableArray *) getPointsFromString:(NSString *)str {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    NSMutableArray *itemArray = [[str componentsSeparatedByString:@","] mutableCopy];
    for(NSString *item in itemArray) {
        NSArray *pointArray = [item componentsSeparatedByString:@";"];
        NSArray *realPointArray = [[pointArray objectAtIndex:0] componentsSeparatedByString:@":"];
        [points addObject:[@{@"latitude" : [realPointArray objectAtIndex:0], @"longitude" : [realPointArray objectAtIndex:1]} mutableCopy]];
    }
    return points;
}


- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
- (BOOL) isFormEmpty:(NSMutableArray *)array {
    BOOL isEmpty = NO;
    for(NSString *str in array) {
        if([str isEqualToString:@""] || [str isEqualToString:@"0"]) {
            isEmpty = YES;
            break;
        }
    }
    return isEmpty;
}
- (void)setFormDic:(NSMutableArray *)array toDic:(NSMutableDictionary *)formDic {
    for(NSDictionary *dic in array) {
        if(!([[dic objectForKey:@"content"] isEqualToString:@""] && [[dic objectForKey:@"content"] isEqualToString:@"0"])) {
            [formDic setObject:[dic objectForKey:@"content"] forKey:[dic objectForKey:@"key"]];
        }
    }
}
- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

- (BOOL)validatePhoneNumber:(NSString *)phoneNumberStr{
    
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phoneNumberStr];
}

- (NSArray *)getSortedArray:(NSArray *)array {
    NSArray *keys = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return keys;
}
- (NSString *)getParamStr:(NSMutableDictionary *) dic {
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    keys = [[dic allKeys] mutableCopy];
    NSString *str = @"";
    int i = 0;
    for(NSString *key in keys) {
        if(i > 0) str = [str stringByAppendingString:@"&"];
        str = [str stringByAppendingString:[key stringByAppendingString:[@"=" stringByAppendingString:[dic objectForKey:key]]]];
        i++;
    }
    return str;
}
- (BOOL)isEmptyString:(NSString *)str {
    if([str isEqualToString:@""] || [str isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }
}

- (UIImage *) getImageFromDic: (NSMutableDictionary *) dic {
    UIImage *image = [[UIImage alloc] init];
    if([[dic objectForKey:@"photo_is_full_url"] isEqualToString:@"1"]) {
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"photo_link"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
    } else {
        image = [UIImage imageNamed:[dic objectForKey:@"photo_link"]];
    }
    return image;
}

- (NSMutableDictionary *)getDictionaryById:(NSMutableArray *)array withIdKey:(NSString *)idField withIdValue:(NSString *)idValue {
    NSMutableDictionary *dicResult = [[NSMutableDictionary alloc] init];
    for(NSMutableDictionary *dic in array) {
        if([[dic objectForKey:idField] isEqualToString:idValue]) {
            dicResult = dic;
            break;
        }
    }
    return dicResult;
}

- (BOOL) checkStringNumeric:(NSString *) str {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:str];
    return !!number; // If the string is not numeric, number will be nil
}
- (NSString *) removeSpaceFromString:(NSString *) str {
    //return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [str stringByReplacingOccurrencesOfString:@"\\s" withString:@""
                                             options:NSRegularExpressionSearch
                                               range:NSMakeRange(0, [str length])];
}
- (NSString *) removeCharactersFromString:(NSString *)str withFormat:(NSArray *) arr {
    NSString *s = str;
    for(NSString *c in arr) {
        s = [s stringByReplacingOccurrencesOfString:c withString:@""];
    }
    return s;
}

- (void) cropCircleView:(UIView *)view {
    view.layer.cornerRadius = view.frame.size.width/2.0f;
    view.clipsToBounds = YES;
    return;
}
- (void) cropCircleImage:(UIImageView *)imageView {
    imageView.layer.cornerRadius = imageView.frame.size.width/2.0f;
    imageView.clipsToBounds = YES;
    return;
}
- (void) setCircleBorderImage:(UIImageView *)imageView withBorderWidth:(float) width withBorderColor:(UIColor *) color {
    [imageView setClipsToBounds:YES];
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (imageView.frame.size.width), (imageView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:imageView.frame.size.width/2];
    [borderLayer setBorderWidth:width];
    [borderLayer setBorderColor:[color CGColor]];
    [imageView.layer addSublayer:borderLayer];
}

- (void) setRoundedRectBorderImage:(UIImageView *)imageView withBorderWidth:(float) width withBorderColor:(UIColor *) color withBorderRadius:(float)radius {
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = radius;
    
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (imageView.frame.size.width), (imageView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:radius];
    [borderLayer setBorderWidth:width];
    [borderLayer setBorderColor:[color CGColor]];
    [imageView.layer addSublayer:borderLayer];
}


- (void) cropCircleButton:(UIButton *)button {
    button.layer.cornerRadius = button.frame.size.width / 2.0f;
    button.clipsToBounds = YES;
}
- (void) setCircleBorderButton:(UIButton *)button withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color {
    button.clipsToBounds = YES;
    button.layer.cornerRadius = button.frame.size.width / 2.0f;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = borderWidth;
}
- (void) setRoundedRectBorderButton:(UIButton *)button withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color withBorderRadius:(float)radius{
    button.clipsToBounds = YES;
    button.layer.cornerRadius = radius;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = borderWidth;
}

- (void) setRoundedRectView:(UIView *)view withCornerRadius:(float)radius {
    view.clipsToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

- (void) setImageViewAFNetworking:(UIImageView *)imageView withImageUrl:(NSString *)imageUrl withPlaceholderImage:(UIImage *)placeholder {
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [imageView setImageWithURLRequest:req placeholderImage:placeholder success:nil failure:nil];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
}
- (void) setButtonImageAFNetworking:(UIButton *)button withImageUrl:(NSString *)imageUrl withPlaceholderImage:(UIImage *)placeholder {
    NSURL *url = [NSURL URLWithString:imageUrl];
    [button setImageForState:UIControlStateNormal withURL:url placeholderImage:placeholder];
    [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
}
- (void)setButtonMultiLineText:(UIButton *)button {
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
}
- (void) setTextFieldBorder:(UITextField *)textField withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius {
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = width;
    textField.layer.cornerRadius = radius;
    textField.layer.masksToBounds = true;
}
- (void) setTextFieldMargin:(UITextField *)textField valX:(float)x valY:(float)y valW:(float)w valH:(float)h {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}
- (void) setTextViewBorder:(UITextView *)textView withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius {
    textView.layer.borderColor = color.CGColor;
    textView.layer.borderWidth = width;
    textView.layer.cornerRadius = radius;
    textView.layer.masksToBounds = true;
}
- (void) setTextViewMargin:(UITextView *)textView valX:(float)x valY:(float)y valW:(float)w valH:(float)h {
    textView.textContainerInset = UIEdgeInsetsMake(x, y, w, h);
}
- (void) setTextViewMarginClear:(UITextView *)textView {
    textView.textContainerInset = UIEdgeInsetsZero;
    textView.textContainer.lineFragmentPadding = 0;
}

- (CGFloat)getHeightForTextContent:(NSString *)text withWidth:(CGFloat)width withFontSize:(CGFloat)fontSize {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
    [textView setFont:[UIFont systemFontOfSize:fontSize]];
    textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [textView setText:text];
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return newSize.height;
}


- (NSString *) trimString:(NSString *)str {
    NSString *str1 = str;
    NSArray* newLineChars = [NSArray arrayWithObjects:@"\\u000a", @"\\u000b",@"\\u000c",@"\\u000d",@"\\u0085",nil];
    
    for( NSString* nl in newLineChars ) {
        str1 = [str1 stringByReplacingOccurrencesOfString: nl withString:@""];
    }
    
    str1 = [str1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str1 = [self removeSpaceFromString:str1];
    return str1;
}

- (NSString *) getCombinedTextByComma:(NSMutableArray *)arr {
    NSString *text = @"";
    BOOL filled = NO;
    for(NSString *str in arr) {
        if(!([str isEqualToString:@""] || [str isEqualToString:@"0"])) {
            if(filled) text = [text stringByAppendingString:@", "];
            text = [text stringByAppendingString:str];
            filled = YES;
        }
    }
    return text;
}

- (NSMutableArray *) sortArrayByInnerDicKey:(NSMutableArray *)array withFormat:(NSString *)innerKey {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:innerKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    arr = [[array sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    return arr;
}

- (NSDate *)convertStringToDate:(NSString *)dateStr withFormat:(NSString *)formatStr {
    
    // convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatStr];
    return [dateFormat dateFromString:dateStr];
}

- (NSString *)convertDateToString:(NSDate *)date withFormat:(NSString *)formatStr {
    
    if(date == nil) {
        return @"";
    }
    // convert date object to string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    
    // optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [formatter stringFromDate:date];
}

- (BOOL)isToday:(NSDate *)date {
    
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    if ([today day] == [otherDay day] &&
        [today month] == [otherDay month] &&
        [today year] == [otherDay year] &&
        [today era] == [otherDay era]) {
        return YES;
    }
    return NO;
}

// Scale image to the specified size
- (UIImage *)cropImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    double ratio;
    double delta;
    CGPoint offset;
    
    double hRatio = newSize.width / image.size.width;
    double vRatio = newSize.height / image.size.height;
    
    // figure out if scaled image offset
    if (hRatio > vRatio) {
        ratio = hRatio;
        delta = (ratio * image.size.height - newSize.height);
        offset = CGPointMake(0, delta / 2);
    } else {
        ratio = vRatio;
        delta = (ratio * image.size.width - newSize.width);
        offset = CGPointMake(delta / 2, 0);
    }
    
    // make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width),
                                 (ratio * image.size.height));
    
    // start a new context, with scale factor 0.0 so retina displays get
    // high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSString *)getContentTypeForImageData:(NSData *)data {
    
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @".jpeg";
        case 0x89:
            return @".png";
        case 0x47:
            return @".gif";
        case 0x49:
            break;
        case 0x42:
            return @".bmp";
        case 0x4D:
            return @".tiff";
    }
    return nil;
}

- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (NSString *)encodeToBase64String:(UIImage *)image byCompressionRatio:(float)compressionRatio {
    NSString *photo = @"";
    NSData *data = UIImageJPEGRepresentation(image, compressionRatio);
    if(data == nil) {
        data = [NSData dataWithData:UIImagePNGRepresentation(image)];
    }
    photo = [NSString base64StringFromData:data length:[data length]];
    //    photo = [photo stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return photo;
    //return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}



- (NSString *)encodeMediaPathToBase64String:(NSString *)mediaPath {
    NSString *media = @"";
    NSData *data = [NSData dataWithContentsOfFile:mediaPath];
    //    media = [NSString base64StringFromData:data length:[data length]];
    media = [data base64EncodedStringWithOptions:0];
    //    photo = [photo stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return media;
    //return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (NSString *)getJsonStringFromDic:(NSMutableDictionary *)array {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
- (void)showActivityIndicator:(UIView *)inView {
    //    [[ActivityIndicator currentIndicator] show];
    if (activityIndicator) {
        [self hideActivityIndicator];
    }
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setHidden:NO];
    activityIndicator.center = inView.center;
    activityIndicator.color = appController.appTextColor;
    [activityIndicator startAnimating];
    [activityIndicator.layer setZPosition:999];
    [inView addSubview:activityIndicator];
    //    [inView setUserInteractionEnabled:NO];
}
- (void)showActivityIndicatorColored:(UIView *)inView {
    //    [[ActivityIndicator currentIndicator] show];
    if (activityIndicator) {
        [self hideActivityIndicator];
    }
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setHidden:NO];
    activityIndicator.center = inView.center;
    activityIndicator.color = appController.appMainColor;
    [activityIndicator startAnimating];
    [activityIndicator.layer setZPosition:999];
    [inView addSubview:activityIndicator];
    //    [inView setUserInteractionEnabled:NO];
}

- (void)showActivityIndicatorThird:(UIView *)inView {
    //    [[ActivityIndicator currentIndicator] show];
    if (activityIndicator) {
        [self hideActivityIndicator];
    }
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setHidden:NO];
    activityIndicator.center = inView.center;
    activityIndicator.color = appController.appThirdColor;
    [activityIndicator startAnimating];
    [activityIndicator.layer setZPosition:999];
    [inView addSubview:activityIndicator];
    //    [inView setUserInteractionEnabled:NO];
}

- (void)hideActivityIndicator {
    //    [[ActivityIndicator currentIndicator] hide];
    //    [activityIndicator.superview setUserInteractionEnabled:YES];
    [activityIndicator setHidden:YES];
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
}


#pragma mark - Custom Functions

- (void)customizeNavigationBar:(UIViewController *)view hideBackButton:(BOOL) option {
    [view.navigationItem setHidesBackButton:option];
    UINavigationController *navController = view.navigationController;
    [navController.navigationItem setHidesBackButton:option];
    
    navController.navigationBar.translucent = YES;
    navController.navigationBar.barTintColor = [UIColor whiteColor];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    //[navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:@"Arial" size: 21.0f]}];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize: 18.0f]}];
    [navController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)setGigUserPhoto:(UIImageView *)imageView byPhotoUrl:(NSString *)photoUrl {
    
    [commonUtils cropCircleImage:imageView];
    [imageView setImage:[UIImage imageNamed:@"profile_photo_icon"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [commonUtils setImageViewAFNetworking:imageView withImageUrl:photoUrl withPlaceholderImage:[UIImage imageNamed:@"profile_photo_icon"]];
   
}

- (void)setGigPhoto:(UIImageView *)imageView byPhotoUrl:(NSString *)photoUrl {
    
    [imageView setImage:[UIImage imageNamed:@"imageview_image"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];    
    [commonUtils setImageViewAFNetworking:imageView withImageUrl:photoUrl withPlaceholderImage:[UIImage imageNamed:@"imageview_image"]];
    
}



//- (NSString *) getFullPhotoUrl:(NSString *)url withType:(NSString *)type {
//    if([type isEqualToString:@"user"] && [url rangeOfString:MEDIA_USER_SELF_DOMAIN_PREFIX].location != NSNotFound) {
//        return [MEDIA_URL_USERS stringByAppendingString:[url substringFromIndex:[MEDIA_USER_SELF_DOMAIN_PREFIX length]]];
//    } else if([type isEqualToString:@"gig"] && [url rangeOfString:MEDIA_GIG_SELF_DOMAIN_PREFIX].location != NSNotFound) {
//        return [MEDIA_URL_GIGS stringByAppendingString:[url substringFromIndex:[MEDIA_GIG_SELF_DOMAIN_PREFIX length]]];
//    } else {
//        return url;
//    }
//}




#pragma mark - Common Httl Request Methods
//
//+ (id) httpCommonRequest:(NSString*) urlStr {
//    NSURL *url = [NSURL URLWithString:urlStr];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *jsonResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    //    NSLog(@"%@", jsonResult);
//    return [[SBJsonParser new] objectWithString:jsonResult];
//}

- (id) httpJsonRequest:(NSString *) urlStr withJSON:(NSMutableDictionary *)params {
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *body = [[SBJsonWriter new] stringWithObject:params];
    NSData *requestData = [body dataUsingEncoding:NSASCIIStringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:API_KEY forHTTPHeaderField:@"api-key"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return [[SBJsonParser new] objectWithString:jsonResult];
}

@end
