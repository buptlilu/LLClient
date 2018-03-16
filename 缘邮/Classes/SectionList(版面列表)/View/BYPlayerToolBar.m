//
//  BYPlayerToolBar.m
//  缘邮
//
//  Created by LiLu on 16/2/29.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYPlayerToolBar.h"
#import "BYSongTimeView.h"
#import "BYSongPlayView.h"

#import "UIButton+CZ.h"
#import "NSString+CZ.h"
#import "UIImage+CZ.h"


@interface BYPlayerToolBar ()


@end

@implementation BYPlayerToolBar

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpAllChildView];
    }
    return self;
}

-(void)setUpAllChildView{
    //timeView
    BYSongTimeView *timeView = [[BYSongTimeView alloc] init];
    [self addSubview:timeView];
    _timeView = timeView;
    
    //playView
    BYSongPlayView *playView = [[BYSongPlayView alloc] init];
    [self addSubview:playView];
    _playView = playView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //timeView
    self.timeView.frame = CGRectMake(0, 0, self.bounds.size.width, 20);
    
    //playView
    CGFloat playViewX = 0;
    CGFloat playViewY = CGRectGetMaxY(self.timeView.frame) - 2;
    CGFloat playViewW = self.bounds.size.width;
    CGFloat playViewH = self.bounds.size.height - playViewY;
    self.playView.frame = CGRectMake(playViewX, playViewY, playViewW, playViewH);
}



@end
