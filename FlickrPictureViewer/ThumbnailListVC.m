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
    [self.flickrManager retrievePictureListWithType:self.pictureListType count:50 completion:
    ^(NSArray* pictureList, NSError* error){
        if (error != nil) {
            // failed.
            // TODO: show error
            return;
        }
        
        if (pictureList == nil) {
            // error
            // TODO: show error
            return;
        }
        
        if (pictureList.count == 0) {
            // error
            // TODO: show error
        }
        
        self.pictureList = pictureList;
        [self.collectionView reloadData];
    }];
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
