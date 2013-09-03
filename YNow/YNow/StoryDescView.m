//
//  StoryDescView.m
//  YNow
//
//  Created by Mohtashim Khan on 9/2/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "StoryDescView.h"

@implementation StoryDescView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
}

-(void)fillStoryWithTitle : (NSString*) aTitle andSrc : (NSString*) aSrc andDate:(NSString*)aDate andDesc : (NSString*) aDesc{
    self.titleLabel.text = aTitle;
    self.srcLabel.text = aSrc;
    self.dateLabel.text = aDate;
    self.descriptionLabel.text = aDesc;
}

-(void)resetAll{
    self.titleLabel.text = self.dateLabel.text = self.srcLabel.text = self.descriptionLabel.text = NULL;
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
