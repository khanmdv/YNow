//
//  CoverflowCell.h
//  YNow
//
//  Created by Mohtashim Khan on 9/5/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CReflectionView.h"

@interface CoverflowCell : UIView

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet CReflectionView *reflectionImage;

@end
