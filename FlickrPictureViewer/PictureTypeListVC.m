//
//  PictureTypeListVC.m
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/04.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import "PictureTypeListVC.h"
#import "ThumbnailListVC.h"
#import "Defines.h"

@interface PictureTypeListVC ()

@end

@implementation PictureTypeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // set picture list type into next screen
    if ([@"MostRecentPictures" isEqualToString:segue.identifier]) {
        ThumbnailListVC *nextViewController = (ThumbnailListVC *)segue.destinationViewController;
        nextViewController.pictureListType = PictureListTypeMostRecent;
    }
    else if ([@"MostInterestingPictures" isEqualToString:segue.identifier]) {
        ThumbnailListVC *nextViewController = (ThumbnailListVC *)segue.destinationViewController;
        nextViewController.pictureListType = PictureListTypeMostInteresting;
    }
}


@end
