//
//  PicturePageVC.h
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picture.h"

@interface PicturePageVC : UIViewController

// These are set by parent.
@property NSUInteger pageIndex;
@property Picture* targetPicture;

@end
