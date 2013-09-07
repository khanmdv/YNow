//
//  Trend.h
//  YNow
//
//  Created by Mohtashim Khan on 9/7/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "RestObject.h"

@interface Trend : RestObject

+ (NSMutableArray *)trendsWithArray:(NSArray *)array;

@property (nonatomic, strong, readonly) NSString* trendUrl;
@property (nonatomic, strong, readonly) NSString* trendText;

+ (NSMutableArray *)trendsWithArray:(NSArray *)array;

@end
