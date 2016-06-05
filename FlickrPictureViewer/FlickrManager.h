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

+ (instancetype)sharedInstance;

// Retrieve picture list from Flicker.
// Specified count of pictures will be retrieved.
// If retreaving succeeded, completion will return pictureList as array of Picture object.
// If retreaving failed, completion will return error and pictureList will be nil.
- (void)retrievePictureListWithType:(PictureListType)type count:(NSUInteger)count completion:(void(^)(NSArray* pictureList, NSError* error))completion;


// Retrieve thumbnail image from Flicker.
// If cached image exists in local, it will be returned without retrieving from Flickr.
// If retreaving succeeded, completion will return image file path.
// If retreaving failed, completion will return error and image file path will be nil.
- (void)retrieveImageOfPicture:(Picture*)picture isThumbnail:(BOOL)isThumbnail completion:(void(^)(NSString* imageFilePath, NSError* error))completion;


// Return filePath if local cache exists.
// If not exists, return nil.
- (NSString*)getLocalCacheImageOfPicture:(Picture*)picture isThumbnail:(BOOL)isThumbnail;

// Delete all cached thumbnails and pictures in ~/Library/Cache/
- (void)deleteAllCacheFile;

@end
