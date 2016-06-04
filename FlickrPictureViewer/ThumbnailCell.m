//
//  ThumbnailCell.m
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import "ThumbnailCell.h"
#import "FlickrManager.h"

@interface ThumbnailCell ()

@property Picture* displayTargetPicture;

@end

@implementation ThumbnailCell

- (id) init {
    if (self = [super init]) {
        self.displayTargetPicture = nil;
    }
    return self;
}

- (void)displayPicture:(Picture*)picture {
    if (picture == self.displayTargetPicture) {
        // Already displayed. Nothing to do.
        return;
    }
    
    self.displayTargetPicture = picture;
    
    // set loading status
    self.imageView.image = nil;
    
    // retrieve thumbnail
    [[FlickrManager sharedInstance] retrieveThumbnailImageOfPicture:picture completion:
    ^(UIImage* image, NSError* error) {
        if (error != nil) {
            // failed.
            // TODO: show error
            return;
        }
        
        if (image == nil) {
            // error
            // TODO: show error
            return;
        }
        
        self.imageView.image = image;
    }];
}

@end

