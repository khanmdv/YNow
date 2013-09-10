//
//  Story.m
//  YNow
//
//  Created by Mohtashim Khan on 9/2/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import "Story.h"
#import "NSString+HTML.h"

#define COVERFLOW_IMG_WIDTH     140;
#define COVERFLOW_IMG_HEIGHT    140;

@implementation Story

@synthesize imgUrl=_imgUrl, imgUrl320=_imgUrl320, storyDate=_storyDate;

+ (NSMutableArray *)storyWithArray:(NSArray *)array {
    NSMutableArray *stories = [[NSMutableArray alloc] initWithCapacity:array.count];
    NSArray *imageArray;
    NSString *imageUrl;
    
    for (NSDictionary *params in array) {
        Story* st = [[Story alloc] initWithDictionary:params];
        imageUrl = @"";
        imageArray = [params objectForKey:@"images"];
        for (NSDictionary *image in imageArray)
        {
            NSNumber *width = [image objectForKey:@"width"];
            NSNumber *height = [image objectForKey:@"height"];
            if ([width intValue] == 140 && [height intValue] == 140){
                imageUrl = [image objectForKey:@"url"];
                break;
            }
        }
        
        if(imageUrl.length >0){
            [stories addObject:st];
        }
    }
    return stories;
}

-(NSString*) imgUrl{
    if (_imgUrl == nil){
        NSArray* imageArray = self.data[@"images"] == nil ? [self.data valueForKey:@"images"] : self.data[@"images"];
        for (NSDictionary *image in imageArray)
        {
            NSNumber *width = [image objectForKey:@"width"];
            NSNumber *height = [image objectForKey:@"height"];
            if ([width intValue] == 140 && [height intValue] == 140){
                _imgUrl = [image objectForKey:@"url"];
                break;
            }
        }
    }
    return _imgUrl;
}

-(NSString*) imgUrl320{
    if (_imgUrl320 == nil){
        NSArray* imageArray = [self.data valueForKey:@"images"];
        for (NSDictionary *image in imageArray)
        {
            NSNumber *width = [image objectForKey:@"width"];
            NSNumber *height = [image objectForKey:@"height"];
            if ([width intValue] == 320 && [height intValue] == 125){
                _imgUrl320 = [image objectForKey:@"url"];
                break;
            }
        }
    }
    return _imgUrl320;
}

-(NSString*) storyTitle{
    return [[self.data valueForKeyPath:@"title"] stringByDecodingHTMLEntities];
}

-(NSString*) shortDesc{
    return [[self.data valueForKeyPath:@"summary"] stringByDecodingHTMLEntities];
}

-(NSString*) storyDate{
    if (_storyDate == nil){
        NSDateFormatter *dFormat = [[NSDateFormatter alloc] init];
        [dFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *dt = [dFormat dateFromString:[self.data valueForKeyPath:@"published"]];
        [dFormat setDateFormat:@"MMM dd"];
        _storyDate = [dFormat stringFromDate:dt];
    }
    return _storyDate;
}

-(NSString*) storyRawDate{
    return [self.data valueForKeyPath:@"published"];
}

-(NSString*) storyId{
    return [self.data valueForKeyPath:@"id"];
}

-(NSString*) source{
    return [self.data valueForKeyPath:@"publisher"];
}

-(NSString*) storyUrl{
    return [self.data valueForKeyPath:@"link"];
}

@end
