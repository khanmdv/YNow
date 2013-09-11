//
//  MoreAppsViewController.m
//  YNow
//
//  Created by Mohtashim Khan on 8/29/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "MoreAppsViewController.h"
#import "CollectionCell.h"

#define kCollectionCell @"CollectionCell"

static NSArray* apps;

@interface MoreAppsViewController ()

@end

@implementation MoreAppsViewController

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
    
    apps = @[ @{
                  @"img" :  @"ymessenger.png",
                  @"url" : @"ymessenger://",
                  @"itunes": @"yahoo!-messenger-free-sms",
                  @"title" :@"Messenger!"
                },
              @{
                  @"img" : @"yweather.jpeg",
                  @"url" : @"yweather://",
                  @"itunes" : @"yahoo!-weather",
                  @"title" : @"Weather!"
                  },
              @{
                  @"img" : @"yfin.png",
                  @"url" : @"yfinance://",
                  @"itunes" : @"yahoo!-finance",
                  @"title" : @"Finance!"
                  },
              @{
                  @"img" : @"flickr.png",
                  @"url" : @"flickr://",
                  @"itunes" : @"flickr",
                  @"title" : @"Flickr"
                  },
              @{
                  @"img" : @"ymail.png",
                  @"url" : @"ymail://",
                  @"itunes" : @"yahoo!",
                  @"title" : @"Mail!"
                  }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCollectionCell];
    self.tabBarController.navigationItem.title = @"More Apps";
}

- (void) viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.title = @"More Yahoo Apps";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.collectionView.frame = CGRectMake(0, 64, 320, 568);
    self.collectionView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    NSLog(@"Insets - %f", self.collectionView.contentInset.top);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:
(NSIndexPath *)indexPath{
    
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCell forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[CollectionCell alloc] init];
    }
    
    NSDictionary* dict = apps[indexPath.row];
    
    cell.appIconView.image = [UIImage imageNamed:dict[@"img"]];
    cell.appName.text = dict[@"title"];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(130, 180.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* appDetails = apps[indexPath.row];
    
    BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appDetails[@"url"]]];
    
    if (canOpenURL){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appDetails[@"url"]]];
    }else{
        NSString* safariUrl = [NSString stringWithFormat:@"itms://itunes.com/apps/%@", appDetails[@"itunes"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:safariUrl]];
    }
}

@end
