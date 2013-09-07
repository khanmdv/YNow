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
#import "CoverflowCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PullUpView.h"

@interface TopStoriesViewController ()

@property (nonatomic, strong) NSMutableArray* stories;
@property (nonatomic, strong, readonly) UIView* cellFromXIB;

- (void)fetchStories;
- (void) updateStoryDescAt: (NSUInteger)index;

@end

@implementation TopStoriesViewController

- (void)fetchStories{
    [[YahooClient instance] getNewsFeed:0 success: ^(AFHTTPRequestOperation *operation, id response) {
        id results = [response valueForKeyPath:@"result.items"];
        if ([results isKindOfClass:[NSArray class]]) {
            [self.stories removeAllObjects];
            self.stories = [Story storyWithArray:results];
            [self.carousel reloadData];
            [self updateStoryDescAt:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"%@",error);
    }];
}

-(void) updateStoryDescAt:(NSUInteger)index{
    Story* st = [self.stories objectAtIndex:index];
    self.titleLbl.text = st.storyTitle;
    self.srcLbl.text = st.source;
    self.dateLbl.text = st.storyDate;
    self.descLbl.text = st.shortDesc;
    NSLog(@"%@", st.storyUrl);
    if (self.webView.loading){
        [self.webView stopLoading];
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

    self.carousel.type = iCarouselTypeCoverFlow2;
    
    // Hide the nav bar
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)cellFromXIB{
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"CoverflowCell" owner:self options:Nil];
    return views[0];
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.stories count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    Story *st = [self.stories objectAtIndex:index];
    CoverflowCell* cell;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = self.cellFromXIB;
        /*
         label = [[UILabel alloc] initWithFrame:view.bounds];
         label.backgroundColor = [UIColor clearColor];
         label.textAlignment = UITextAlignmentCenter;
         label.font = [label.font fontWithSize:50];
         label.tag = 1;
         [view addSubview:label];*/
    }
    
    cell = (CoverflowCell*)view;
    
    //[imgView setImageWithURL:[NSURL URLWithString:st.imgUrl]];
    [cell.image setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:st.imgUrl]] placeholderImage:[UIImage imageNamed:@"page.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.image.image = image;
        cell.reflectionImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Unable to fetch image");
    }];
    
    view.contentMode = UIViewContentModeScaleAspectFit;
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = st.storyTitle;
    
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140.0f, 140.0f)];
        view.contentMode = UIViewContentModeScaleAspectFit;
        /*
         label = [[UILabel alloc] initWithFrame:view.bounds];
         label.backgroundColor = [UIColor clearColor];
         label.textAlignment = UITextAlignmentCenter;
         label.font = [label.font fontWithSize:50.0f];
         label.tag = 1;
         [view addSubview:label];*/
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    //NSNumber *item = (self.items)[index];
    //NSLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    [self updateStoryDescAt:self.carousel.currentItemIndex];
}

#pragma mark - UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error loading the story." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //[alert show];
}


-(void) viewCompleteStory : (UIPanGestureRecognizer*) panGesture{
    CGPoint point = [panGesture translationInView:panGesture.view];
    NSLog(@"%f", point.y);
    
    if (point.y < 0){
        self.carousel.hidden = YES;
    } else{
        self.carousel.hidden = NO;
    }
}

#pragma mark - PullUPDelegate Methods

- (void) viewInMotion : (UIView*)aView direction : (PullDirection) aDirection{
    CGFloat alpha = self.carousel.alpha;
    if (aDirection == PULLUP && alpha > 0.0){
        alpha-=0.05;
    }else if (aDirection == PULLDOWN && alpha < 1) {
        alpha+=0.05;
    }else{
        return;
    }
    
    self.carousel.alpha = alpha;
}

- (void) endMotionInView : (UIView*) aView direction : (PullDirection) aDirection{
    if (aDirection == PULLDOWN){
        self.carousel.alpha = 1.0;
        self.carousel.hidden = NO;
        self.carousel.layer.zPosition = 0.8;
    }else{
        self.carousel.alpha = 0.1;
        self.carousel.hidden = YES;
        self.carousel.layer.zPosition = 0;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"I did scroll");
}
- (IBAction)pullDownStoryView:(id)sender {
    PullUpView* view = (PullUpView*)self.descView;
    self.carousel.alpha = 1.0;
    self.carousel.hidden = NO;
    self.carousel.layer.zPosition = 0.8;
    self.descView.layer.zPosition = 1.0;
    [view restoreOriginalPosition:YES];
}
@end
