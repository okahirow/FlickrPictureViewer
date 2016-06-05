//
//  FlickrManager.m
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import "FlickrManager.h"
#import "AFNetworking.h"

static NSString* apiKey = @"d5c7df3552b89d13fe311eb42715b510";


@implementation FlickrManager

#pragma mark public methods

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)retrievePictureListWithType:(PictureListType)type count:(NSUInteger)count completion:(void(^)(NSArray* pictureList, NSError* error))completion {
    // Delete all image cache.
    // Because server images may be updated, so previous cache will be useless.
    [[FlickrManager sharedInstance] deleteAllCacheFile];
    
    // Reqyest picture list to server
    NSString* pictureListTypeString = (type == PictureListTypeMostRecent) ? @"recent" : @"interestingness";
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:@"https://query.yahooapis.com/v1/public/yql"];
    NSURLQueryItem *item1 = [NSURLQueryItem queryItemWithName:@"q" value:[NSString stringWithFormat:@"select * from flickr.photos.%@(0,%lu)where api_key='%@'", pictureListTypeString, (unsigned long)count, apiKey]];
    NSURLQueryItem *item2 = [NSURLQueryItem queryItemWithName:@"diagnostics" value:@"true"];
    NSURLQueryItem *item3 = [NSURLQueryItem queryItemWithName:@"format" value:@"json"];
    components.queryItems = @[item1, item2, item3];
    NSURL *URL = [components URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil
    success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSMutableArray* pictureList = [@[] mutableCopy];
        
        NSArray* photos = [responseObject valueForKeyPath:@"query.results.photo"];
        for (NSDictionary* photo in photos) {
            Picture* picture = [[Picture alloc] initWithJsonData: photo];
            [pictureList addObject:picture];
        }
        
        completion(pictureList, nil);
    }
    failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
}

- (void)retrieveImageOfPicture:(Picture*)picture forThumbnail:(BOOL)forThumbnail completion:(void(^)(UIImage* image, NSError* error))completion {
    // Retrieve thumbnail in background thread for performance
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        // Check cache exists
        NSURL* cacheImageFileURL = [self imageCacheFileUrlOfPicture:picture isThumbnai:forThumbnail];
        NSData* imageData = [NSData dataWithContentsOfFile:cacheImageFileURL.path];
        if (imageData != nil) {
            // Return cache image in UI thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* image = [UIImage imageWithData:imageData];
                completion(image, nil);
            });
            return;
        }
        
        // Request image to server and save retrieved image into cache.
        NSString* thumbnailTypeString = forThumbnail ? @"_t_d" : @"";
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@%@.jpg", picture.farm, picture.server, picture.pictureId, picture.secret, thumbnailTypeString]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil
        destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            // set download path
            return [self imageCacheFileUrlOfPicture:picture isThumbnai:forThumbnail];
        }
        completionHandler:^(NSURLResponse *response, NSURL *fileUrl, NSError *error) {
            // this block will be called in background thread.
            
            if (error != nil || fileUrl == nil) {
                // return in UI thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, error);
                });
                return;
            }
            
            NSData* imageData = [NSData dataWithContentsOfFile:fileUrl.path];
            if (imageData == nil) {
                // error
                // return in UI thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, nil);
                });
                return;
            }
            
            NSLog(@"File downloaded to: %@", fileUrl.path);
            
            // return in UI thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* image = [UIImage imageWithData:imageData];
                completion(image, nil);
            });
        }];
        [downloadTask resume];
    });
}

- (UIImage*)getCacheImageOfPicture:(Picture*)picture forThumbnail:(BOOL)forThumbnail {
    NSURL* localImageFileURL = [self imageCacheFileUrlOfPicture:picture isThumbnai:forThumbnail];
    return [UIImage imageWithContentsOfFile:localImageFileURL.path];
}

- (void)deleteAllCacheFile {
    // Delete thumbnail cache folder.
    NSURL* thumbnailCacheDir = [self imageCacheDirUrlWithIsThumbnail:YES];
    [[NSFileManager defaultManager] removeItemAtPath:thumbnailCacheDir.path error:nil];
    
    // Delete picture cache folder.
    NSURL* pictureCacheDir = [self imageCacheDirUrlWithIsThumbnail:YES];
    [[NSFileManager defaultManager] removeItemAtPath:pictureCacheDir.path error:nil];
}


#pragma mark private methods

- (NSURL*)imageCacheFileUrlOfPicture:(Picture*)picture isThumbnai:(BOOL)isThumbnail {
    NSURL* imageCacheDirUrl = [self imageCacheDirUrlWithIsThumbnail:isThumbnail];
    
    // If directory does not exist, create it.
    [[NSFileManager defaultManager] createDirectoryAtPath:imageCacheDirUrl.path withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSURL* imageCacheFileUrl = [imageCacheDirUrl URLByAppendingPathComponent:[self imageCacheFileNameOfPicture:picture]];
    return imageCacheFileUrl;
}

- (NSURL*)imageCacheDirUrlWithIsThumbnail:(BOOL)isThumbnail {
    NSURL* cacheDirectoryURL = [NSURL fileURLWithPath:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]];
    
    if (isThumbnail) {
        return [cacheDirectoryURL URLByAppendingPathComponent:@"Thumbnails" isDirectory:YES];
    }
    else {
        return [cacheDirectoryURL URLByAppendingPathComponent:@"Pictures" isDirectory:YES];
    }
}

- (NSString*)imageCacheFileNameOfPicture:(Picture*)picture {
    NSString* fileName = [NSString stringWithFormat:@"%@_%@_%@.jpg", picture.farm, picture.server, picture.pictureId];
    return fileName;
}

@end
