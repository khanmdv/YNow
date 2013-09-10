//
//  TrendingWebViewController.h
//  YNow
//
//  Created by Prasanth Sivanappan on 06/09/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trend.h"

@interface TrendingWebViewController : UIViewController<UIWebViewDelegate>

@property(strong,atomic) Trend *trend;

@property(nonatomic,retain) IBOutlet UIWebView *webView;

@end
