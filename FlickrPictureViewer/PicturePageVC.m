//
//  PicturePageVC.m
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import "PicturePageVC.h"
#import "FlickrManager.h"

@interface PicturePageVC ()

@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* loadingView;

@end

@implementation PicturePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self displayPicture:self.targetPicture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayPicture:(Picture*)picture {
    // Display loading view
    self.loadingView.hidden = NO;
    
    // Display thumbnail
    [self displayThumbnailIfExists: self.targetPicture];
    
    // Retrieve full size picture
    [[FlickrManager sharedInstance] retrieveImageOfPicture:picture isThumbnail:NO completion:
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
         
         UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
         if (image == nil) {
             // error
             // TODO: show error
             return;
         }
         
         self.imageView.image = image;
         self.loadingView.hidden = YES;
     }];
}

- (void)displayThumbnailIfExists:(Picture*)picture {
    // Get local thumbnail cache
    NSString* thumbnailFilePath = [[FlickrManager sharedInstance] getLocalCacheImageOfPicture:picture isThumbnail:YES];
    UIImage *image = [UIImage imageWithContentsOfFile:thumbnailFilePath];
    if (image == nil) {
        // No thumbnail cache.
        // Do nothing.
        return;
    }
    
    self.imageView.image = image;
    self.loadingView.hidden = YES;
}


@end
