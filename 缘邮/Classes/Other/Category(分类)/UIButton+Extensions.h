//
//  UIButton+Extensions.h
//  sw-reader
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extensions)
/**
 *  扩大按钮点击区域 [button setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
 */
@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;
@end
