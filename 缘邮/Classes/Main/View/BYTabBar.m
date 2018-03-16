//
//  BYTabBar.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYTabBar.h"
#import "BYTabBarButton.h"


@interface BYTabBar ()

@property(nonatomic, strong)NSMutableArray *buttons;
@property(nonatomic, weak) UIButton *selectedButton;
@end
@implementation BYTabBar

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)setItems:(NSArray *)items{
    _items = items;
    
    //遍历数组模型，按钮的内容由模型决定
    for (UITabBarItem *item in _items) {
        BYTabBarButton *btn = [BYTabBarButton buttonWithType:UIButtonTypeCustom];
        btn.item = item;
        btn.tag = self.buttons.count;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        //默认停在首页
        if (btn.tag == 1) {
            [self btnClick:btn];
        }
     
        [self addSubview:btn];
        
        //添加到按钮数组
        [self.buttons addObject:btn];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = self.width;
    CGFloat h = self.height;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = w / self.items.count;
    CGFloat btnH = h;
    
    int i = 0;
    //跳转系统自带的tabBar上的按钮的位置
    for (UIView *tabBarButton in self.buttons) {
        //判断是否是我们自定义的按钮tabBarButton
        if ([tabBarButton isKindOfClass:NSClassFromString(@"BYTabBarButton")]) {
            btnX = i * btnW;
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i++;
        }
    }
}

-(void)btnClick:(UIButton *)btn{
    _selectedButton.selected = NO;
    btn.selected = YES;
    _selectedButton = btn;
    
    //通知控制器点击了哪个按钮
    if ([self.delegate respondsToSelector:@selector(tabBar:didClickButton:)]) {
        [self.delegate tabBar:self didClickButton:btn.tag];
    }
}

@end
