//
//  BYTabBarButton.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYTabBarButton.h"
#import "BYBadgeView.h"

#define BYImageRidio 0.7

@interface BYTabBarButton ()

@property(nonatomic, weak) BYBadgeView *badgeView;

@end

@implementation BYTabBarButton

//重写方法取消高亮做的事情
-(void)setHighlighted:(BOOL)highlighted{
    
}

-(BYBadgeView *)badgeView{
    if (!_badgeView) {
        BYBadgeView *btn = [BYBadgeView buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:btn];
        
        _badgeView = btn;
    }
    return _badgeView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        
        //图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        
        //文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //设置文字字体
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

//传值模型时赋值
-(void)setItem:(UITabBarItem *)item{
    _item = item;
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
    //kvo：时刻监听一个对象的数学是否有改变
    [item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
}

//主要监听的属性有新值，就调用
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self setTitle:_item.title forState:UIControlStateNormal];
    
    [self setImage:_item.image forState:UIControlStateNormal];
    
    [self setImage:_item.selectedImage forState:UIControlStateSelected];
    
    // 设置badgeValue
    self.badgeView.badgeValue = _item.badgeValue;
}

//修改按钮内部的子控件frame
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //1.iamgeView
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.bounds.size.width;
    CGFloat imageH = self.bounds.size.height * BYImageRidio;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    //2.title
    CGFloat titleX = 0;
    CGFloat titleY = imageH - 3;
    CGFloat titleW = self.bounds.size.width;
    CGFloat titleH = self.bounds.size.height - titleY;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    //3.badgeView
    self.badgeView.x = self.width - self.badgeView.width - 10;
    self.badgeView.y = 0;

}

@end
