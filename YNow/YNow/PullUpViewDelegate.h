//
//  PullUpViewDelegate.h
//  YNow
//
//  Created by Mohtashim Khan on 9/6/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PULLUP, PULLDOWN
} PullDirection;

@protocol PullUpViewDelegate <NSObject>

@optional

- (void) viewInMotion : (UIView*)aView direction : (PullDirection) aDirection;
- (void) endMotionInView : (UIView*) aView direction : (PullDirection) aDirection;

@end
