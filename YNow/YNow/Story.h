//
//  Story.h
//  YNow
//
//  Created by Mohtashim Khan on 9/2/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestObject.h"

@interface Story : RestObject

@property (nonatomic, strong, readonly) NSString* imgUrl;
@property (nonatomic, strong, readonly) NSString* imgUrl320;
@property (nonatomic, strong, readonly) NSString* storyTitle;
@property (nonatomic, strong, readonly) NSString* shortDesc;
@property (nonatomic, strong, readonly) NSString* storyDate;
@property (nonatomic, strong, readonly) NSString* source;
@property (nonatomic, strong, readonly) NSString* storyId;
@property (nonatomic, strong, readonly) NSString* storyUrl;

+ (NSMutableArray *)storyWithArray:(NSArray *)array;

@end
