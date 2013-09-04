//
//  TopStoriesViewController.m
//  YNow
//
//  Created by Mohtashim Khan on 9/2/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "TopStoriesViewController.h"
#import "Util.h"
#import "Story.h"
#import "StoryDescView.h"
#import "CCoverflowCollectionViewLayout.h"
#import "CoverflowCollectionCell.h"
#import "YahooClient.h"
#import <UIImageView+AFNetworking.h>

@interface TopStoriesViewController ()

@property (nonatomic, strong) NSMutableArray* stories;
@property (readwrite, nonatomic, strong) StoryDescView *titleView;

@end

@implementation TopStoriesViewController

- (void)updateStoryDesc
{
	NSIndexPath *theIndexPath = ((CCoverflowCollectionViewLayout*)self.collectionView.collectionViewLayout).currentIndexPath;
    
	if (theIndexPath == NULL)
    {
		[self.titleView resetAll];
    }
	else
    {
        Story* story = [self.stories objectAtIndex:theIndexPath.row];
        [self.titleView fillStoryWithTitle:story.title
                                    andSrc:@"yahoo.com"
                                   andDate:story.date
                                   andDesc:story.desc];
    }
}

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
    self.stories = [NSMutableArray array];
    [self fetchStories];
    //self.stories = [Util getTestData];
    [self.collectionView registerNib:[UINib nibWithNibName:@"StoryDescView"
                                                    bundle:[NSBundle mainBundle]]
          forSupplementaryViewOfKind:@"title"
                 withReuseIdentifier:@"title"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CoverflowCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CoverFlowCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.stories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CoverflowCollectionCell *theCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CoverFlowCell" forIndexPath:indexPath];
    
	if (theCell.gestureRecognizers.count == 0) {
		[theCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)]];
    }
    
	theCell.backgroundColor = [UIColor colorWithHue:(float)indexPath.row / (float)self.stories.count saturation:0.333 brightness:1.0 alpha:1.0];
    
	if (indexPath.row < self.stories.count) {
		Story *story = [self.stories objectAtIndex:indexPath.row];
		[theCell.imageView setImageWithURL:[NSURL URLWithString:story.imgUrl]];
		theCell.reflectionImageView.image = theCell.imageView.image;
		theCell.backgroundColor = [UIColor clearColor];
    }
    
	return theCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
	StoryDescView *theView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                     withReuseIdentifier:@"title"
                                                                            forIndexPath:indexPath];
    
	self.titleView = theView;
	[self updateStoryDesc];
	return theView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self updateStoryDesc];
}

- (void)tapCell:(UITapGestureRecognizer *)inGestureRecognizer {
	NSIndexPath *theIndexPath = [self.collectionView indexPathForCell:(UICollectionViewCell *)inGestureRecognizer.view];
    
	NSLog(@"%@", [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:theIndexPath]);
}

- (void)fetchStories{
    [[YahooClient instance] getNewsFeed:0 success: ^(AFHTTPRequestOperation *operation, id response) {
        id results = [response valueForKeyPath:@"result.items"];
        if ([results isKindOfClass:[NSArray class]]) {
            [self.stories removeAllObjects];
            self.stories = [Story storyWithArray:results];
            [self.collectionView reloadData];
        }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"%@",error);
        }
    ];

}


@end
