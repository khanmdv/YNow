//
//  Trend.m
//  YNow
//
//  Created by Mohtashim Khan on 9/7/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "Trend.h"

@implementation Trend

@synthesize trendUrl=_trendUrl;

+ (NSMutableArray *)trendsWithArray:(NSArray *)array {
    NSMutableArray *trends = [[NSMutableArray alloc] initWithCapacity:array.count];
    int i = 1;
    for (NSDictionary *params in array) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:params];
        dict[@"rating"] = @(i++);
        [trends addObject:[[Trend alloc] initWithDictionary:dict]];
    }
    return trends;
}

-(NSString*) trendUrl{
    if (_trendUrl == nil){
        _trendUrl = [[NSString stringWithFormat:@"http://m.yahoo.com/w/search?p=%@", self.trendText] stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding] ;
    }
    return _trendUrl;
}

-(NSString*) trendText{
    return [[self.data valueForKeyPath:@"title"] capitalizedString];
}

-(int) trendRating{
    return [[self.data valueForKeyPath:@"rating"] intValue];
}

@end
