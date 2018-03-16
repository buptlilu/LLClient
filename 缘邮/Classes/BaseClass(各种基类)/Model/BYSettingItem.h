//
//  BYSettingItem.h
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYSettingItem : NSObject

/**
 *  描述imageView
 */
@property(nonatomic, strong) UIImage *image;
/**
 *  描述textLabel
 */
@property(nonatomic, copy) NSString *title;
/**
 *  描述detailLabel
 */
@property(nonatomic, copy) NSString *subTitle;

@property(nonatomic, copy) void(^option)(BYSettingItem *item);

/**
 *  跳转控制器的类名
 */
@property(nonatomic, assign) Class destVcClass;

+(instancetype)itemWithTitle:(NSString *)title;
+(instancetype)itemWithImage:(UIImage *)image title:(NSString *)title;
+(instancetype)itemWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle;


@end
