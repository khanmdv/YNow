//
//  YahooClient.m
//  YNow
//
//  Created by Prasanth Sivanappan on 03/09/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "YahooClient.h"

#define BASE_URL [NSURL URLWithString:@"http://mhr.yql.yahoo.com/"]

@implementation YahooClient

+ (YahooClient *)instance {
    static dispatch_once_t once;
    static YahooClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[YahooClient alloc] initWithBaseURL:BASE_URL];
    });
    
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:BASE_URL];
    if (self != nil) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}


#pragma mark - YAHOO API

- (void)getNewsFeed:(int)show_ad success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"show_ads": @(show_ad)}];
    [params setObject:@"json" forKey:@"format"];
    [self getPath:@"v1/newsfeed" parameters:params success:success failure:failure];
}

- (void)getTrends:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure {

    NSURL *url = [NSURL URLWithString:@"http://api.timesense.yahoo.com:4080/timesense/v3/en-US/topbuzzing?clientid=demo&count=15&format=json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    
    [operation start];
    
}
@end
