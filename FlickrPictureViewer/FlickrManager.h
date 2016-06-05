//
//  FlickrManager.h
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "Picture.h"

@interface FlickrManager : NSObject

// Singleton
+ (instancetype)sharedInstance;

// Retrieve picture list from Flicker.
// Specified count of pictures will be retrieved.
// If retrieving succeeded, completion will return pictureList as array of Picture object.
// If retrieving failed, completion will return error and pictureList will be nil.
// completion will be called in UI thread.
- (void)retrievePictureListWithType:(PictureListType)type count:(NSUInteger)count completion:(void(^)(NSArray* pictureList, NSError* error))completion;

// Retrieve thumbnail image from Flicker.
// If cached image exists, it will be returned without retrieving from Flickr.
// If retrieving succeeded, completion will return UIImage object.
// If retrieving failed, completion will return error and image will be nil.
// completion will be called in UI thread.
- (void)retrieveImageOfPicture:(Picture*)picture forThumbnail:(BOOL)forThumbnail completion:(void(^)(UIImage* image, NSError* error))completion;

// Return UIImage object if cache exists.
// If not exists, return nil.
// This method must be called in UI thread.
- (UIImage*)getCacheImageOfPicture:(Picture*)picture forThumbnail:(BOOL)forThumbnail;

// Delete all cached thumbnails and pictures in ~/Library/Cache/
- (void)deleteAllCacheFile;

@end
