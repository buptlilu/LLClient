//
//  BYSongPlayView.m
//  缘邮
//
//  Created by LiLu on 16/3/1.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYSongPlayView.h"

#import "UIImage+CZ.h"
#import "UIButton+CZ.h"

@implementation BYSongPlayView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self setUpAllChildView];
        self.image = [UIImage imageNamed:@"play_bar_bg2"];
    }
    return self;
}

-(void)setUpAllChildView{
    //用户头像
    UIImageView *singerImgView = [[UIImageView alloc] init];
    singerImgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:singerImgView];
    _singerImgView = singerImgView;
    
    //歌曲名字
    UILabel *musicNameLabel = [[UILabel alloc] init];
    musicNameLabel.font = [UIFont systemFontOfSize:13];
    musicNameLabel.textColor = [UIColor whiteColor];
    musicNameLabel.text = @"label";
    [self addSubview:musicNameLabel];
    _musicNameLabel = musicNameLabel;
    
    //歌手名字
    UILabel *singerNameLabel = [[UILabel alloc] init];
    singerNameLabel.font = [UIFont systemFontOfSize:13];
    singerNameLabel.textColor = [UIColor whiteColor];
    singerNameLabel.text = @"label";
    [self addSubview:singerNameLabel];
    _singerNameLabel = singerNameLabel;
    
    //播放按钮
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setNBg:@"playbar_playbtn_click" hBg:@"playbar_playbtn_normal"];
    [self addSubview:playBtn];
    _playBtn = playBtn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //歌手头像
    CGFloat singerImgViewXY = 5;
    CGFloat singerImgViewWH = self.bounds.size.height - 2 * singerImgViewXY;
    self.singerImgView.frame = CGRectMake(singerImgViewXY, singerImgViewXY, singerImgViewWH, singerImgViewWH);
    
    //播放按钮
    CGFloat playMargin = 3;
    CGFloat playWH = self.bounds.size.height - 2 * playMargin;
    CGFloat playX = self.bounds.size.width - playWH - playMargin;
    CGFloat playY = playMargin;
    self.playBtn.frame = CGRectMake(playX, playY, playWH, playWH);
    
    //音乐名字
    CGFloat musicMargin = 10;
    CGFloat musicNameH = 21;
    CGFloat musicNameX = CGRectGetMaxX(self.singerImgView.frame) + musicMargin;
    CGFloat musicNameW = self.bounds.size.width - musicNameX - musicMargin - (self.bounds.size.width - playX);
    CGFloat musicNameY =  4;
    self.musicNameLabel.frame = CGRectMake(musicNameX, musicNameY, musicNameW, musicNameH);
    
    //歌手名字
    CGFloat singerNameY = CGRectGetMaxY(self.musicNameLabel.frame) + 4;
    self.singerNameLabel.frame = CGRectMake(musicNameX, singerNameY, musicNameW, musicNameH);
    
    self.singerImgView.layer.masksToBounds = YES;
    self.singerImgView.layer.cornerRadius = singerImgViewWH * 0.5;
}

@end
