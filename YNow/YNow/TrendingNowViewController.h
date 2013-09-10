//
//  TrendingNowViewController.h
//  YNow
//
//  Created by Mohtashim Khan on 8/29/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendingNowViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* spinner;

@end
