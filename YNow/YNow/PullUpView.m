//
//  PullUpView.m
//  YNow
//
//  Created by Mohtashim Khan on 9/6/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "PullUpView.h"
#import <QuartzCore/QuartzCore.h>


@interface PullUpView ()

@property (nonatomic, assign) float start;
@property (nonatomic, assign) CGRect origLocation;

@end

@implementation PullUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.origLocation = self.frame;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.origLocation = self.frame;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"I am starting");
    // We do not want more than 1 touch input
    if (touches.count > 1) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.start = point.y;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"I am moving");
    // We do not want more than 1 touch input
    if (touches.count > 1) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    float diff = self.start - point.y;
    
    CGRect fr = self.frame;
    if (point.y > self.start){ // down direction
        fr.origin.y += diff;
    } else{
        fr.origin.y -= diff;
    }
    self.frame = fr;
    if (self.delegate){
        [self.delegate viewInMotion:self direction: diff >= 0 ? PULLUP : PULLDOWN];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    float diff = self.start - point.y;
    
    if (point.y < 50){
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, -188.0, self.origLocation.size.width, self.origLocation.size.height);
        }];
    }else if (point.y > self.origLocation.origin.y){
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.origLocation;
        }];
    }
    if (self.delegate){
        [self.delegate endMotionInView:self direction:diff >= 0 ? PULLUP : PULLDOWN];
    }
    self.start = 0.0;
}

-(void) restoreOriginalPosition : (BOOL) animated{
    if (animated){
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.origLocation;
        }];
    }else{
        self.frame = self.origLocation;
    }
}

@end
