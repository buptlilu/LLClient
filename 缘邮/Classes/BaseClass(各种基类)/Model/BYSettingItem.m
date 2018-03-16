//
//  BYSettingItem.m
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYSettingItem.h"

@implementation BYSettingItem

+(instancetype)itemWithTitle:(NSString *)title{
    return [self itemWithImage:nil title:title subTitle:nil];
}

+(instancetype)itemWithImage:(UIImage *)image title:(NSString *)title{
    return [self itemWithImage:image title:title subTitle:nil];
}

+(instancetype)itemWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle{
    BYSettingItem *item = [[self alloc] init];
    item.title = title;
    item.subTitle = subTitle;
    item.image = image;
    return item;
}


@end
