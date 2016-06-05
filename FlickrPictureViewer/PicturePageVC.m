//
//  PicturePageVC.m
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import "PicturePageVC.h"
#import "FlickrManager.h"

@interface PicturePageVC () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* loadingView;
@property UIImageView* imageView;

@end

@implementation PicturePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set image view into scroll view.
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.delegate = self;
    
    [self displayPicture:self.targetPicture];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Reset zoom mode
    [self.scrollView setZoomScale:1.0];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Reset zoom mode
    [self.scrollView setZoomScale:1.0];
    
    // Reset imageView layout
    self.imageView.frame = self.view.bounds;
    self.scrollView.contentSize = self.imageView.bounds.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayPicture:(Picture*)picture {
    // Display loading view
    [self displayLoadingView];
    
    // Display thumbnail
    [self displayThumbnailIfExists: self.targetPicture];
    
    // Retrieve full size picture
    [[FlickrManager sharedInstance] retrieveImageOfPicture:picture isThumbnail:NO completion:
     ^(NSString* imageFilePath, NSError* error) {
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
         [self displayImage:image];
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

- (void)displayLoadingView {
    self.loadingView.hidden = NO;
}

- (void)displayErrorView {
    // Reset zoom mode
    [self.scrollView setZoomScale:1.0];
    
    self.imageView.image = nil;
    self.loadingView.hidden = YES;
    
    UILabel* errorView = [[UILabel alloc] initWithFrame:self.view.bounds];
    errorView.text = @"Cannot retrieve picture.";
    errorView.textAlignment = NSTextAlignmentCenter;
    
    [self.scrollView addSubview:errorView];
    self.scrollView.contentSize = errorView.bounds.size;
    
    // Disable zooming
    self.scrollView.maximumZoomScale = 1.0;
}

- (void)displayImage:(UIImage*)image {
    self.imageView.image = image;
    self.loadingView.hidden = YES;
}


#pragma mark <UIScrollViewDelegate>

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


@end
