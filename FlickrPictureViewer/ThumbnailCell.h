//
//  ThumbnailCell.h
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picture.h"

@interface ThumbnailCell : UICollectionViewCell

 
- (void)displayPicture:(Picture*)picture;

@end
