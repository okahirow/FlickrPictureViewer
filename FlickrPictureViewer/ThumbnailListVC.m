//
//  ThumbnailListVC.m
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/04.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import "ThumbnailListVC.h"


typedef NS_ENUM (NSUInteger, ThumbnailListStatus) {
    Loading,
    LoadedAndMoreDataExists,
    LoadedAndNoMoreData,
};


@interface ThumbnailListVC ()

@property ThumbnailListStatus status;
@property NSMutableArray* pictureList;

@end


@implementation ThumbnailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.collectionView.alwaysBounceVertical = YES;
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.pictureList = [@[] mutableCopy];
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
    self.status = Loading;
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.status) {
        case Loading:
            return self.pictureList.count + 1;  // + 1 is for loading cell
        case LoadedAndMoreDataExists:
            return self.pictureList.count + 1;  // + 1 is for see more cell
        case LoadedAndNoMoreData:
            return self.pictureList.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    if (indexPath.row < self.pictureList.count) {
        // thumbnail cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbnailCell" forIndexPath:indexPath];
    }
    else {
        if (self.status == Loading) {
            // loading cell
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LoadingCell" forIndexPath:indexPath];
        }
        else {
            // see more cell
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SeeMoreCell" forIndexPath:indexPath];
        }
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.pictureList.count) {
        // thumbnail cell
        // Go to detali screen.
    }
    else {
        if (self.status == Loading) {
            // loading cell
            // Do nothing.
        }
        else {
            // see more cell
            // Retrieve picture list.
        }
    }
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
