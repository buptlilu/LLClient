//
//  BYSongPlayView.h
//  缘邮
//
//  Created by LiLu on 16/3/1.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYSongPlayView : UIImageView

@property (strong, nonatomic)  UIImageView *singerImgView;//歌手头像
@property (strong, nonatomic)  UILabel *musicNameLabel;//歌曲的名字
@property (strong, nonatomic)  UILabel *singerNameLabel;//歌手名字
@property (strong, nonatomic)  UIButton *playBtn;

@end
