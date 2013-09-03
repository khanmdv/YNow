//
//  CoverflowCollectionCell.h
//  YNow
//
//  Created by Mohtashim Khan on 9/2/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "CBetterCollectionViewCell.h"
#import "CReflectionView.h"

@interface CoverflowCollectionCell : CBetterCollectionViewCell

@property (readwrite, nonatomic, weak) IBOutlet UIImageView *imageView;
@property (readwrite, nonatomic, weak) IBOutlet CReflectionView *reflectionImageView;

@end
