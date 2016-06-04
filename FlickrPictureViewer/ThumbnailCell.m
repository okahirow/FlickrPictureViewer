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

@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, weak) IBOutlet UIView* defaultView;

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
    
    // Set loading status
    self.imageView.image = nil;
    self.defaultView.hidden = NO;
    
    // retrieve thumbnail
    [[FlickrManager sharedInstance] retrieveImageOfPicture:picture isThumbnail:YES completion:
    ^(NSString* imageFilePath, NSError* error) {
        if (error != nil) {
            // failed.
            // TODO: show error
            return;
        }
        
        if (imageFilePath == nil) {
            // error
            // TODO: show error
            return;
        }
        
        if ([picture isEqual:self.displayTargetPicture] == false) {
            // Now this cell is displayed another picture.
            // Nothing to do.
            return;
        }
        
        UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
        if (image == nil) {
            // error
            // TODO: show error
            return;
        }
        
        // Set loaded status
        self.imageView.image = image;
        self.defaultView.hidden = YES;
    }];
}

@end

