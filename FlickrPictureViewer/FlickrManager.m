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

- (void)retrieveImageOfPicture:(Picture*)picture isThumbnail:(BOOL)isThumbnail completion:(void(^)(NSString* imageFilePath, NSError* error))completion {
    // Check is image exists in cache
    NSString* filePath = [self getLocalCacheImageOfPicture:picture isThumbnail:isThumbnail];
    if (filePath != nil) {
        // Return cache file
        completion(filePath, nil);
        return;
    }
    
    // Request image to server.
    NSString* thumbnailTypeString = isThumbnail ? @"_t_d" : @"";
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@%@.jpg", picture.farm, picture.server, picture.pictureId, picture.secret, thumbnailTypeString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [self imageCacheFileUrlOfPicture:picture isThumbnai:isThumbnail];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error != nil) {
            completion(nil, error);
            return;
        }
        
        if (filePath == nil) {
            //error
            completion(nil, nil);
            return;
        }
        
        NSLog(@"File downloaded to: %@", filePath.path);
        completion(filePath.path, nil);
    }];
    [downloadTask resume];
}

- (NSString*)getLocalCacheImageOfPicture:(Picture*)picture isThumbnail:(BOOL)isThumbnail {
    NSURL* localImageFileURL = [self imageCacheFileUrlOfPicture:picture isThumbnai:isThumbnail];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localImageFileURL.path]) {
        // Return cache file
        return localImageFileURL.path;
    }
    
    return nil;
}

- (void)deleteAllCacheFile {
    // Delete thumbnail cache folder.
    NSURL* thumbnailCacheDir = [self imageCacheDirUrlWithIsThumbnail:YES];
    [[NSFileManager defaultManager] removeItemAtPath:thumbnailCacheDir.path error:nil];
    
    // Delete picture cache folder.
    NSURL* pictureCacheDir = [self imageCacheDirUrlWithIsThumbnail:YES];
    [[NSFileManager defaultManager] removeItemAtPath:pictureCacheDir.path error:nil];
}

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
