//
//  ThumbnailListVC.m
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/04.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import "ThumbnailListVC.h"
#import "FlickrManager.h"
#import "ThumbnailCell.h"
#import "DetailVC.h"

@interface ThumbnailListVC ()

@property NSArray* pictureList;
@property FlickrManager* flickrManager;

@end


@implementation ThumbnailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.collectionView.alwaysBounceVertical = YES;
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.flickrManager = [FlickrManager sharedInstance];
    self.pictureList = nil; // nil means not yet retrieved.
    [self updateNavigationTitle];
    [self retrievePictureList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateNavigationTitle {
    switch (self.pictureListType) {
        case PictureListTypeMostRecent:
            self.title = @"Most recent pictures";
            break;
        case PictureListTypeMostInteresting:
            self.title = @"Most interesting pictures";
            break;
    }
}

- (void)retrievePictureList {
    [self.flickrManager retrievePictureListWithType:self.pictureListType count:100 completion:
    ^(NSArray* pictureList, NSError* error){
        if (error != nil || pictureList == nil) {
            // error
            UIAlertController* dialog = [UIAlertController alertControllerWithTitle:@"Error" message:@"Cannot retrieve picture list." preferredStyle: UIAlertControllerStyleAlert];
            [dialog addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:dialog animated:YES completion:nil];
            
            self.pictureList = @[];
        }
        else {
            self.pictureList = pictureList;
        }
        
        [self.collectionView reloadData];
    }];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.pictureList == nil) {
        // loading
        return 1;   // loading cell
    }
    else {
        // loaded
        return self.pictureList.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pictureList == nil) {
        // loading
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"LoadingCell" forIndexPath:indexPath];
    }
    else {
        // thumbnail cell
        ThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbnailCell" forIndexPath:indexPath];
        Picture* picture = self.pictureList[indexPath.row];
        [cell displayPicture:picture];
        return cell;
    }
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pictureList == nil) {
        // loading
        // Do nothing.
    }
    else {
        // thumbnail cell
        // Go to detali screen.
        DetailVC* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
        detailVC.pictureList = self.pictureList;
        detailVC.initialPictureIndex = indexPath.row;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
