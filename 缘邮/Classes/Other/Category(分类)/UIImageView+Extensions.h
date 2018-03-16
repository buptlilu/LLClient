//
//  UIImageView+Extensions.h
//  sw-reader
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 YouDao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extensions)
/**
 *  扩大按钮点击区域 [imageView setHitTestEdgeInsets:UIEdgeInsetsMake(-5, -5, -5, -5)];
 */
@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;
@end
