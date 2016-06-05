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
@property (nonatomic, weak) IBOutlet UIView* loadingView;
@property (nonatomic, weak) IBOutlet UIView* errorView;

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
    
    [self displayLoadingView];
    
    // retrieve thumbnail
    [[FlickrManager sharedInstance] retrieveImageOfPicture:picture isThumbnail:YES completion:
    ^(NSString* imageFilePath, NSError* error) {
        if ([picture isEqual:self.displayTargetPicture] == false) {
            // Now this cell is displayed another picture.
            // Nothing to do.
            return;
        }

        if (error != nil) {
            // error
            [self displayErrorView];
            return;
        }
        
        if (imageFilePath == nil) {
            // error
            [self displayErrorView];
            return;
        }
        
        UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
        if (image == nil) {
            // error
            [self displayErrorView];
            return;
        }
        
        // Success
        [self displayThumbnail:image];
    }];
}

- (void)displayLoadingView {
    self.imageView.image = nil;
    self.loadingView.hidden = NO;
    self.errorView.hidden = YES;
}

- (void)displayErrorView {
    self.imageView.image = nil;
    self.loadingView.hidden = YES;
    self.errorView.hidden = NO;
}

- (void)displayThumbnail:(UIImage*)image {
    self.imageView.image = image;
    self.loadingView.hidden = YES;
    self.errorView.hidden = YES;
}

@end

