//
//  YahooClient.h
//  YNow
//
//  Created by Prasanth Sivanappan on 03/09/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface YahooClient : AFHTTPClient

+ (YahooClient *)instance;

- (void)getNewsFeed:(int)show_ad success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
