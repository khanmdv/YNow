//
//  StoryDescView.h
//  YNow
//
//  Created by Mohtashim Khan on 9/2/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryDescView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *srcLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

-(void)fillStoryWithTitle : (NSString*) aTitle andSrc : (NSString*) aSrc andDate:(NSString*)aDate andDesc : (NSString*) aDesc;
-(void)resetAll;


@end
