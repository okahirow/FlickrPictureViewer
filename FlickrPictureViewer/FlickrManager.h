//
//  FlickrManager.h
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"
#import "Picture.h"

@interface FlickrManager : NSObject

+ (instancetype)sharedInstance;

// Retrieve picture list from Flicker.
// Specified count of pictures will be retrieved.
// If retreaving succeeded, completion will return pictureList as array of Picture object.
// If retreaving failed, completion will return error and pictureList will be nil.
- (void)retrievePictureListWithType:(PictureListType)type count:(NSUInteger)count completion:(void(^)(NSArray* pictureList, NSError* error))completion;


// Retrieve thumbnail image from Flicker.
// If cached image exists in local, it will be returned without retrieving from Flickr.
// If retreaving succeeded, completion will return image.
// If retreaving failed, completion will return error and image will be nil.
- (void)retrieveThumbnailImageOfPicture:(Picture*)picture completion:(void(^)(UIImage* image, NSError* error))completion;

@end
