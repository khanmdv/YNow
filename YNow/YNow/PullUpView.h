//
//  PullUpView.h
//  YNow
//
//  Created by Mohtashim Khan on 9/6/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullUpViewDelegate.h"

@interface PullUpView : UIView

@property (nonatomic, weak) IBOutlet id<PullUpViewDelegate> delegate;

-(void) restoreOriginalPosition : (BOOL) animated;
@end
