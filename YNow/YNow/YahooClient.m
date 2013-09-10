//
//  YahooClient.m
//  YNow
//
//  Created by Prasanth Sivanappan on 03/09/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "YahooClient.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

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

-(NSDictionary*) dictFromManagedObject: (NSManagedObject *) oneObject{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    dict[@"title"] = [oneObject valueForKey:@"storyTitle"];
    NSDictionary* images = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:140], @"width",
                       [NSNumber numberWithInt:140], @"height",
                       [oneObject valueForKey:@"imgUrl"], @"url", nil];
    
    dict[@"images"] = [NSArray arrayWithObject:images];
    dict[@"summary"] = [oneObject valueForKey:@"shortDesc"];
    dict[@"publisher"] = [oneObject valueForKey:@"publisher"];
    dict[@"published"] = [oneObject valueForKey:@"published"];
    dict[@"link"] = [oneObject valueForKey:@"storyUrl"];
    dict[@"id"] = [oneObject valueForKey:@"storyId"];
    
    return dict;
}

- (void)getSavedStories:(void (^)(id JSON))success failure:(void (^)(id JSON))failure{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    AppDelegate* delegate = (AppDelegate*)appDelegate;
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Saved"
                                              inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"uniqueId" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if (objects == nil) {
        NSLog(@"There was an error!");
        failure(nil);
        return;
    }
    
    NSMutableArray* tempArr =[ NSMutableArray array];
    for (NSManagedObject *oneObject in objects) {
        NSDictionary* dict = [self dictFromManagedObject:oneObject];
        [tempArr addObject:dict];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        success(tempArr);
    });
}

- (BOOL) saveStory:(Story*)st{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    AppDelegate* delegate = (AppDelegate*)appDelegate;
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSError *error;
    int32_t uniqueId = 0;
    
    // Check if an object already exists, if yes then save it
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Saved"
                                              inManagedObjectContext:context];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"uniqueId" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSManagedObject *obj = nil;
    
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if (objects == nil || objects.count == 0) {
        uniqueId = 1;
    }
    
    if ([objects count] > 0){
        obj = [objects objectAtIndex:0];
        uniqueId = [[obj valueForKey:@"uniqueId"] intValue];
        uniqueId++;
    }
    
    obj = [NSEntityDescription
           insertNewObjectForEntityForName:@"Saved"
           inManagedObjectContext:context];
    
    
    [obj setValue:[NSNumber numberWithInt:uniqueId] forKey:@"uniqueId"];
    [obj setValue:st.storyUrl forKey:@"storyUrl"];
    [obj setValue:st.storyTitle forKey:@"storyTitle"];
    [obj setValue:st.imgUrl forKey:@"imgUrl"];
    [obj setValue:st.shortDesc forKey:@"shortDesc"];
    [obj setValue:st.source forKey:@"publisher"];
    if (st.storyRawDate != nil && ![st.storyRawDate isEqualToString:@""]){
        [obj setValue:st.storyRawDate forKey:@"published"];
    }else{
        [obj setValue:@"" forKey:@"published"];
    }
    [obj setValue:st.storyId forKey:@"storyId"];
    
    [delegate saveContext];
    if(error == nil) return YES;
    return NO;
}

- (BOOL) removeStory:(Story*)st{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    AppDelegate* delegate = (AppDelegate*)appDelegate;
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Saved"
                                              inManagedObjectContext:context];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDescription];
    NSPredicate *pred = [NSPredicate
                     predicateWithFormat:@"(storyId = %@)", st.storyId];
    [request setPredicate:pred];
    
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if (objects == nil || [objects count] == 0) {
        return NO;
    }else{
        [context deleteObject:[objects objectAtIndex:0]];
        [delegate saveContext];
        return YES;
    }
}

- (BOOL) isFavorited : (Story*) st{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    AppDelegate* delegate = (AppDelegate*)appDelegate;
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Saved"
                                              inManagedObjectContext:context];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDescription];
    NSPredicate *pred = [NSPredicate
                         predicateWithFormat:@"(storyId = %@)", st.storyId];
    [request setPredicate:pred];
    
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if (objects == nil || [objects count] == 0) {
        return NO;
    }else{
        return YES;
    }
}

@end
