//
//  CollectionCell.h
//  YNow
//
//  Created by Mohtashim Khan on 9/10/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *appIconView;
@property (weak, nonatomic) IBOutlet UILabel *appName;

@end
