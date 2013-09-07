//
//  CoverflowCollectionCell.m
//  YNow
//
//  Created by Mohtashim Khan on 9/2/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "CoverflowCollectionCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CoverflowCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // make sure we rasterize nicely for retina
        self.imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.imageView.layer.shouldRasterize = YES;
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
