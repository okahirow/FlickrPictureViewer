//
//  FlickrManager.h
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@interface FlickrManager : NSObject

+ (instancetype)sharedInstance;

// Retrieve picture list from Flicker.
// Max 50 pictures will be retrieved.
// If retreaving succeeded, completion will return pictureList as array of Picture object.
// If retreaving failed, completion will return error and pictureList will be nil.
- (void)retrievePictureListWithType:(PictureListType)type completion:(void(^)(NSArray* pictureList, NSError* error))completion;


@end
