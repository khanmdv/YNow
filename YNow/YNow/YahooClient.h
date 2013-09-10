//
//  YahooClient.h
//  YNow
//
//  Created by Prasanth Sivanappan on 03/09/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "Story.h"

@interface YahooClient : AFHTTPClient

+ (YahooClient *)instance;

- (void)getNewsFeed:(int)show_ad success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getTrends:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

- (void)getSavedStories:(void (^)(id JSON))success failure:(void (^)(id JSON))failure;

- (BOOL) saveStory:(Story*)st;

- (BOOL) removeStory:(Story*)st;

- (BOOL) isFavorited : (Story*) st;

@end
