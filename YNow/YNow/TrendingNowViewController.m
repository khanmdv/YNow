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
@interface TrendingNowViewController ()
@property (nonatomic, strong) NSMutableArray* stories;
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
    [[YahooClient instance] getNewsFeed:0 success: ^(AFHTTPRequestOperation *operation, id response) {
        id results = [response valueForKeyPath:@"result.items"];
        if ([results isKindOfClass:[NSArray class]]) {
            [self.stories removeAllObjects];
            self.stories = [Story storyWithArray:results];
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"%@",error);
    }
     ];

   
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
    return [self.stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    // Configure the cell...
        Story *story = [self.stories objectAtIndex:indexPath.row];
    
        cell.textLabel.text = story.title;
    return cell;
}


@end
