//
//  Story.m
//  YNow
//
//  Created by Mohtashim Khan on 9/2/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "Story.h"

@implementation Story

@synthesize imgUrl, title, desc, date;

-(id) initWithImg: ( NSString*) aImgUrl title : (NSString*) aTitle desc : (NSString*) aDesc andDate:(NSString *)aDate{
    self = [super init];
    
    if (self){
        self.imgUrl = aImgUrl;
        self.title = aTitle;
        self.desc = aDesc;
        self.date = aDate;
    }
    
    return self;
}

+ (NSMutableArray *)storyWithArray:(NSArray *)array {
    NSMutableArray *stories = [[NSMutableArray alloc] initWithCapacity:array.count];
    NSArray *imageArray;
    NSString *pDate, *title, *desc, *imageUrl;
    NSDateFormatter *dFormat = [[NSDateFormatter alloc] init];
    NSDate *date;
    for (NSDictionary *params in array) {
        [dFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        imageUrl = @"";
        imageArray = [params objectForKey:@"images"];
        for (NSDictionary *image in imageArray)
        {
            NSNumber *width = [image objectForKey:@"width"];
            if ([width intValue] > 120){
                imageUrl = [image objectForKey:@"url"];
            }
            
        }
        
        pDate = [params valueForKeyPath:@"published"];
        title = [params valueForKeyPath:@"title"];
        desc = [params valueForKeyPath:@"summary"];
        date = [dFormat dateFromString:pDate];
        [dFormat setDateFormat:@"MMM dd, yyyy hh:mm"];
        pDate = [dFormat stringFromDate:date];
        if(imageUrl.length >0){
            [stories addObject:[[Story alloc] initWithImg:imageUrl title:title desc:desc andDate:pDate]];
        }
    }
    return stories;
}


@end
