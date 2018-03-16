//
//  UILabel+BY.m
//  缘邮
//
//  Created by lilu on 2017/6/7.
//  Copyright © 2017年 chujunhe1234. All rights reserved.
//

#import "UILabel+BY.h"

@implementation UILabel (BY)
+ (instancetype)labelWith:(UIFont *)font textColor:(DKColorPicker)picker textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [UILabel new];
    label.dk_textColorPicker = picker;
    label.font = font;
    label.textAlignment = textAlignment;
    return label;
}
@end
