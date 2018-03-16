//
//  BYPlayerToolBar.h
//  缘邮
//
//  Created by LiLu on 16/2/29.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYSongPlayView, BYSongTimeView;
@interface BYPlayerToolBar : UIView

/**
 *  播放状态 默认暂停状态
 */
@property(nonatomic, assign,getter=isPlaying) BOOL playing;

@property(nonatomic, strong) BYSongTimeView *timeView;
@property(nonatomic, strong) BYSongPlayView *playView;

@end
