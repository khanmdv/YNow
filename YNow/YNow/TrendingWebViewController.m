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

    // Do any additional setup after loading the view from its nib.
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    _spinner.frame = CGRectMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)+40,100,100);
    [[[_webView subviews] objectAtIndex:0] addSubview:_spinner];

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
    [_spinner stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_spinner startAnimating];
}
@end
