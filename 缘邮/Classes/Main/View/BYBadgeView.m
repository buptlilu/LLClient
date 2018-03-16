//
//  BYBadgeView.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBadgeView.h"


#define BYBadgeViewFont [UIFont systemFontOfSize:11]


@implementation BYBadgeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        
        //设置字体大小
        self.titleLabel.font = BYBadgeViewFont;
        
        [self sizeToFit];
    }
    return self;
}

-(void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue;
    
    //判断badegValue是否有值
    if (badgeValue.length == 0 || [badgeValue isEqualToString:@"0"]) {
        //没有内容或者空字符串，等于0
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    
    //判断badgeValue文字的尺寸是否大于图片尺寸，大于就显示小点
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = BYBadgeViewFont;
    CGSize size = [badgeValue sizeWithAttributes:attr];
    
    if (size.width > self.width) {
        //文字的尺寸大于控件的宽度
        [self setImage:[UIImage imageNamed:@"new_dot"]  forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        [self setTitle:badgeValue forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }
}

@end
