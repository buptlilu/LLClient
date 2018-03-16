//
//  UIView+BY.m
//  缘邮
//
//  Created by lilu on 2017/6/7.
//  Copyright © 2017年 chujunhe1234. All rights reserved.
//

#import "UIView+BY.h"

@implementation UIView (BY)
+ (instancetype)spaceView {
    UIView *view = [UIView new];
    view.dk_backgroundColorPicker = DKColor_BORDER;
    return view;
}
@end
