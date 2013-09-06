//
//  TrendingNowViewController.m
//  YNow
//
//  Created by Mohtashim Khan on 8/29/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "TrendingNowViewController.h"
#import "YahooClient.h"
#import "Story.h"
#import "TrendingWebViewController.h"
@interface TrendingNowViewController ()
@property (nonatomic, strong) NSMutableArray* trends;
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
    UIEdgeInsets inset = UIEdgeInsetsMake(60, 0, 50, 0);
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
    [self fetchTrends];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    // Reload my data
    [self fetchTrends];
    [refresh endRefreshing];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.trends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    // Configure the cell...
    Story *story = [self.trends objectAtIndex:indexPath.row];
    cell.textLabel.text = story.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    Story *story = [self.trends objectAtIndex:indexPath.row];
    NSString * storyLink = story.imgUrl;
    if (storyLink != nil && ![storyLink isEqualToString:@""]) {
        //        NSString* strUrl = [storyLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* webStringURL = [storyLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:webStringURL];
        TrendingWebViewController *detailViewController = [[TrendingWebViewController alloc] initWithNibName:@"TrendingWebViewController" bundle:nil];
        detailViewController.url = url;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (void) fetchTrends{
    
    [[YahooClient instance] getTrends:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id results = [JSON valueForKeyPath:@"topics"];
        if ([results isKindOfClass:[NSArray class]]) {
            [self.trends removeAllObjects];
            self.trends = [Story trendsWithArray:results];
            [self.tableView reloadData];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@",error);
    }
     ];
    
}

@end
