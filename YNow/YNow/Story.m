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

@end
