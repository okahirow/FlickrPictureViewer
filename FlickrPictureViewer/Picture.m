//
//  Picture.m
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import "Picture.h"

@implementation Picture

- (id)initWithJsonData:(NSDictionary*)json {
    if (self = [super init]) {
        self.pictureId = json[@"id"];
        self.farm = json[@"farm"];
        self.server = json[@"server"];
        self.secret = json[@"secret"];
    }
    return self;
}

- (BOOL)isEqual:(Picture*)picture {
    if ([self.pictureId isEqual:picture.pictureId] &&
        [self.farm isEqual:picture.farm] &&
        [self.server isEqual:picture.server] &&
        [self.secret isEqual:picture.secret])
    {
        return true;
    }
    
    return false;
}

@end
