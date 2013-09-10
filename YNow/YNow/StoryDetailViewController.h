//
//  StoryDetailViewController.h
//  YNow
//
//  Created by Mohtashim Khan on 9/9/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@interface StoryDetailViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic, strong) Story* story;

@end
