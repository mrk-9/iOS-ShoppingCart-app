//
//  WriteReviewViewController.h
//  SCANAPP
//
//  Created by Jose on 4/29/16.
//  Copyright © 2016 Jose. All rights reserved.
//

#import "BaseViewController.h"

@interface WriteReviewViewController : BaseViewController<RateViewDelegate>
@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
