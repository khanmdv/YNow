//
//  Story.h
//  YNow
//
//  Created by Mohtashim Khan on 9/2/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject

@property (nonatomic, strong) NSString* imgUrl;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSString* date;

-(id) initWithImg: ( NSString*) aImgUrl title : (NSString*) aTitle desc : (NSString*) aDesc andDate:(NSString*)aDate;

@end
