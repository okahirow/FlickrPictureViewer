//
//  DetailVC.h
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVC : UIViewController

// These properties will be set by parent view controller.
@property NSArray* pictureList;
@property NSUInteger initialPictureIndex;

@end
