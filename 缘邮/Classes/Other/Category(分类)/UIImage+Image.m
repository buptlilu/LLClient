//
//  UIImage+Image.m
//  个人微博
//
//  Created by LiLu on 15/11/22.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+(instancetype)imageWithOriginalName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+(instancetype)imageWithStretchableName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end
