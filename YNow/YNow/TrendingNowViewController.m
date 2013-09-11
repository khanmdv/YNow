//
//  TrendingNowViewController.m
//  YNow
//
//  Created by Mohtashim Khan on 8/29/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "TrendingNowViewController.h"
#import "YahooClient.h"
#import "Trend.h"
#import "TrendingWebViewController.h"
#import "Util.h"
#import "HPLTagCloudGenerator.h"

@interface TrendingNowViewController ()

@property (nonatomic, strong) NSMutableArray* trends;
@property (nonatomic, strong) NSMutableDictionary *trendsMap;
@property (nonatomic, strong) UIButton* refreshBtn;


-(void) generateWordCloud;

@end

@implementation TrendingNowViewController

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
    
    [self fetchTrends];
    
    self.refreshBtn = [[UIButton alloc] init];
    self.refreshBtn.frame=CGRectMake(0,0,24,24);
    [self.refreshBtn setBackgroundImage:[UIImage imageNamed: @"refresh.png"] forState:UIControlStateNormal];
    [self.refreshBtn addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.refreshBtn];
    self.tabBarController.navigationItem.title = @"Trending Topics";
}

-(void)handleRefresh {
    // Reload my data
    UIView* view = self.mainScrollView.subviews[0];
    [view removeFromSuperview];
    [self fetchTrends];
}

-(void) generateWordCloud{
    NSMutableDictionary* tags = [NSMutableDictionary dictionaryWithCapacity:self.trends.count];
    
    self.trendsMap = [NSMutableDictionary dictionaryWithCapacity:self.trends.count];
    for(Trend* tr in self.trends){
        tags[tr.trendText] = [NSString stringWithFormat:@"%d", tr.trendRating];
        self.trendsMap[tr.trendText] = tr;
    }
    
    HPLTagCloudGenerator *tagGenerator = [[HPLTagCloudGenerator alloc] init];
    tagGenerator.size = CGSizeMake(self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height);
    tagGenerator.tagDict = tags;
    
    NSArray *views = [tagGenerator generateTagViews];
    
    __weak id me = self;
    dispatch_async( dispatch_get_main_queue(), ^{
        // This runs in the UI Thread
        UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 520, 768)];
        for(UIView *v in views) {
            UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:me action:@selector(trendTapped:)];
            v.userInteractionEnabled = YES;
            [v addGestureRecognizer:tapGesture];
            
            // Add tags to the view we created it for
            [tagView addSubview:v];
        }
        [self.mainScrollView addSubview:tagView];
        self.mainScrollView.contentSize = CGSizeMake(520, 768);
        self.mainScrollView.contentOffset = CGPointMake(50, 50);
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchTrends{
    self.tabBarController.navigationItem.title = @"Loading...";
    [self.spinner setHidden:NO];
    [self.spinner startAnimating];
    [[YahooClient instance] getTrends:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id results = [JSON valueForKeyPath:@"topics"];
        if ([results isKindOfClass:[NSArray class]]) {
            [self.trends removeAllObjects];
            self.trends = [Trend trendsWithArray:results];
            [self generateWordCloud];
            self.tabBarController.navigationItem.title = @"Trending Topics";
            [self.spinner stopAnimating];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UIScrollVIewdelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [self.mainScrollView.subviews objectAtIndex:0];
}

-(void) trendTapped :(UITapGestureRecognizer*) tapGesture{
    NSLog(@"I got tapped");
    UILabel* lblTapped = (UILabel*) tapGesture.view;
    Trend* tr = self.trendsMap[lblTapped.text];
    
    if (tr){
        TrendingWebViewController* trendingVC = [[TrendingWebViewController alloc] init];
        trendingVC.trend = tr;
        [self.navigationController pushViewController:trendingVC animated:YES];
    }
}

@end
