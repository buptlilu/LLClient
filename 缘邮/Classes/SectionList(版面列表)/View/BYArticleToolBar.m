//
//  BYArticleToolBar.m
//  缘邮
//
//  Created by LiLu on 16/2/23.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYArticleToolBar.h"

@interface BYArticleToolBar ()



@end


@implementation BYArticleToolBar

- (UIPickerView *)pageView{
    if (!_pageView) {
        _pageView = [[UIPickerView alloc] init];
        [self addSubview:_pageView];
    }
    return _pageView;
}

- (NSMutableArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray array];
        [self addBtnWithTag:0 title:@"上一页"];
        [self addBtnWithTag:1 title:@"下一页"];
        [self addBtnWithTag:2 title:@"跳转"];
        [self addBtnWithTag:3 title:@"回复"];
    }
    return _btns;
}

- (void)addBtnWithTag:(NSInteger) tag title:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [self addSubview:btn];
    [self.btns addObject:btn];
}

- (void)btnClick:(UIButton *)btn{
    //通知控制器点击了哪个按钮
    if ([self.delegate respondsToSelector:@selector(articleToolBar:didClickButton:)]) {
        [self.delegate articleToolBar:self didClickButton:btn.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.width / 5;
    CGFloat btnH = self.height;
    
    int i = 0;
    for (UIButton *btn in self.btns) {
        btnX = i * btnW;
        if (i == 1) {
            i++;
        }
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        i++;
    }
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14 / 2);
    rotate = CGAffineTransformScale(rotate, 1, 1);
    [self.pageView setTransform:rotate];
    
    self.pageView.frame = CGRectMake(2 * btnW, btnY, btnW, btnH);
    self.pageView.backgroundColor = [UIColor clearColor];
    self.pageView.center = CGPointMake(self.width / 2, self.height / 2);
    [[[self.pageView subviews] objectAtIndex:1] setHidden:YES];
    [[[self.pageView subviews] objectAtIndex:2] setHidden:YES];
    
    
    self.userInteractionEnabled = YES;
}

@end
