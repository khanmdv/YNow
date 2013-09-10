//
//  TrendingWebViewController.m
//  YNow
//
//  Created by Prasanth Sivanappan on 06/09/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "TrendingWebViewController.h"

@interface TrendingWebViewController ()

@end

@implementation TrendingWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.trend){
        // Do any additional setup after loading the view from its nib.
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.trend.trendUrl]]];
        self.title = @"Loading...";
    }
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    // Reload my data
    NSString *fullURL = @"http://www.umutcankoseali.com/";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
    [refresh endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = self.trend.trendText;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}
@end
