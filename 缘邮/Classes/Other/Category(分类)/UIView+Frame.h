//
//  UIView+Frame.h
//  个人微博
//
//  Created by LiLu on 15/11/24.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

//分类不能添加成员属性
//@property如果在分类里面，只会生产get、set方法的声明，不会生成成员属性，和方法的实现
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;


@end
