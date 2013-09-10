//
//  MyStoriesViewController.m
//  YNow
//
//  Created by Mohtashim Khan on 8/29/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "MyStoriesViewController.h"
#import "SavedStoryCell.h"
#import <UIImageView+AFNetworking.h>
#import "Story.h"
#import "YahooClient.h"
#import "StoryDetailViewController.h"

#define kSAVED_CELL @"SavedCell"

@interface MyStoriesViewController ()

@property (strong, nonatomic) NSMutableArray* stories;

@end

@implementation MyStoriesViewController

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

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchSavedStories) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SavedStoryCell" bundle:nil] forCellReuseIdentifier:kSAVED_CELL];
    
    self.tabBarController.navigationItem.title = @"My Stories";
    self.tabBarController.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBarHidden = NO;
    
    [self fetchSavedStories];
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tableView.frame = CGRectMake(0, 64, 320, 568);
    NSLog(@"Insets - %f", self.tableView.contentInset.top);
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

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Story *st = self.stories[indexPath.row];
        NSLog(@"%@", st.storyId);
        if ( [[YahooClient instance] removeStory:st]){
            [self.stories removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stories count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSAVED_CELL];
    
    SavedStoryCell* tCell = (SavedStoryCell*)cell;
    
    // Configure the cell...
    Story *st = [self.stories objectAtIndex:indexPath.row];
    
    [tCell.imageView setImageWithURL:[NSURL URLWithString:st.imgUrl]];
    tCell.titleLbl.text = st.storyTitle;
    tCell.srcLbl.text = st.source;
    tCell.dateLbl.text = st.storyDate;
    tCell.descLbl.text = st.shortDesc;
    
    return tCell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    Story *st = self.stories[indexPath.row];
    StoryDetailViewController* storyDetailVC = [[StoryDetailViewController alloc] init];
    storyDetailVC.story = st;
    [self.navigationController pushViewController:storyDetailVC animated:YES];
}

- (void) fetchSavedStories{
    [self.refreshControl beginRefreshing];
    [[YahooClient instance] getSavedStories:^(id JSON) {
        [self.refreshControl endRefreshing];
        id results = JSON;
        if ([results isKindOfClass:[NSArray class]]) {
            [self.stories removeAllObjects];
            self.stories = [Story storyWithArray:results];
            [self.tableView reloadData];
        }
    } failure:^(id JSON) {
        NSLog(@"Error Occurred.");
    }];
}

- (void) editRows{
    
}

@end
