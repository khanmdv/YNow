//
//  StoryDetailViewController.m
//  YNow
//
//  Created by Mohtashim Khan on 9/9/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "StoryDetailViewController.h"
#import <Twitter/Twitter.h>

@interface StoryDetailViewController ()

@end

@implementation StoryDetailViewController

@synthesize story;

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
    
    if (self.story){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:story.storyUrl]]];
        self.title = @"Loading...";
    }
    
    UIButton *button1 = [[UIButton alloc] init];
    button1.frame=CGRectMake(0,0,24,24);
    [button1 setBackgroundImage:[UIImage imageNamed: @"share.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(shareStory:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = self.story.storyTitle;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.title = @"Error";
}

- (IBAction)shareStory:(id)sender {
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:@"Share On"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:Nil
                                                   otherButtonTitles:@"Facebook", @"Twitter", nil];
    [shareSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* service = nil;
    if (buttonIndex == 0){
        // Facebook
        service = SLServiceTypeFacebook;
    } else if(buttonIndex == 1) {
        // Twitter
        service = SLServiceTypeTwitter;
    } else if (buttonIndex == 2){
        return;
    }
    
    //Create the tweet sheet
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:service];
    
    //Customize the tweet sheet here
    //Add a tweet message
    [tweetSheet setInitialText:self.story.storyTitle];
    
    [tweetSheet addURL:[NSURL URLWithString:self.story.storyUrl]];
    
    //Set a blocking handler for the tweet sheet
    tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
        [self dismissViewControllerAnimated:YES
                                 completion:^{}];
    };
    
    //Show the tweet sheet!
    [self presentViewController:tweetSheet
                       animated:YES
                     completion:^{}];
    
}



@end
