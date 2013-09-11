//
//  CoverflowCell.m
//  YNow
//
//  Created by Mohtashim Khan on 9/5/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "CoverflowCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CoverflowCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.7].CGColor;
        self.layer.borderWidth = 4.0;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
