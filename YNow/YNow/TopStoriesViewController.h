//
//  TopStoriesViewController.h
//  YNow
//
//  Created by Mohtashim Khan on 9/2/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "PullUpViewDelegate.h"

@interface TopStoriesViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, UIWebViewDelegate, PullUpViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *srcLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)pullDownStoryView:(id)sender;

@end
