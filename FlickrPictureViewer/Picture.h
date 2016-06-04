//
//  Picture.h
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picture : NSObject

@property NSString* pictureId;
@property NSString* farm;
@property NSString* server;
@property NSString* secret;

- (id)initWithJsonData:(NSDictionary*)json;

- (BOOL)isEqual:(Picture*)picture;

@end
