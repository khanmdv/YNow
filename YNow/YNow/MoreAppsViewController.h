//
//  MoreAppsViewController.h
//  YNow
//
//  Created by Mohtashim Khan on 8/29/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreAppsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
