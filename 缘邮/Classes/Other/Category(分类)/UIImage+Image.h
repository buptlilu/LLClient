//
//  UIImage+Image.h
//  个人微博
//
//  Created by LiLu on 15/11/22.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

//instancetype默认会识别当前是哪个类或者对象调用,就会转换成对应的类对象

//加载原始的图片，没有渲染
+(instancetype)imageWithOriginalName:(NSString *)imageName;

+(instancetype)imageWithStretchableName:(NSString *)imageName;

@end
