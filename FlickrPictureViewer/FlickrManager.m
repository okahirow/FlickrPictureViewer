//
//  FlickrManager.m
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import "FlickrManager.h"

static NSString* apiKey = @"d5c7df3552b89d13fe311eb42715b510";

@implementation FlickrManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)retrievePictureListWithType:(PictureListType)type completion:(void(^)(NSArray* pictureList, NSError* error))completion {
    
    
    
}

@end
