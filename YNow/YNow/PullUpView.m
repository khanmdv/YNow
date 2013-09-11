//
//  PullUpView.m
//  YNow
//
//  Created by Mohtashim Khan on 9/6/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#define kOFFSET_YPOS    -188.0
#define kPULL_THRESHOLD 120.0

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
    CGPoint point = [touch locationInView:self.superview];
    CGPoint prev = [touch previousLocationInView:self.superview];
    
    CGRect fr = self.frame;
    if (point.y > prev.y){ // down direction
        fr.origin.y+=12;
    } else{
        fr.origin.y-=12;
    }
    self.frame = fr;
    
    NSLog(@"Y = %f", self.frame.origin.y);
    if (self.delegate){
        [self.delegate viewInMotion:self direction:(prev.y > point.y ? PULLUP : PULLDOWN)];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    CGPoint prev = [touch previousLocationInView:self.superview];
    
    void(^onFinish)(PullDirection dir) = ^(PullDirection dir){
        if (self.delegate){
            [self.delegate endMotionInView:self direction:dir];
        }
    };
    
    NSLog(@"Ending at Y = %f", prev.y);
    if (point.y < kPULL_THRESHOLD){
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, kOFFSET_YPOS, self.origLocation.size.width, self.origLocation.size.height);
        } completion:^(BOOL finished) {
            if (finished && self.delegate){
                onFinish(PULLUP);
            }
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.origLocation;
        } completion:^(BOOL finished) {
            if (finished && self.delegate){
                onFinish(PULLDOWN);
            }
        }];
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

-(void) switchReadStoryMode: (BOOL) animated onFinish : (OnPullUpFinish) onFinish{
    if (animated){
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, kOFFSET_YPOS, self.origLocation.size.width, self.origLocation.size.height);
    } completion:^(BOOL finished) {
        onFinish(finished);
    }];
    }else{
        self.frame = CGRectMake(0, kOFFSET_YPOS, self.origLocation.size.width, self.origLocation.size.height);
    }
}

@end
