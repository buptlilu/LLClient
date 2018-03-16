//
//  BYSongTimeView.h
//  缘邮
//
//  Created by LiLu on 16/3/1.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYSongTimeView : UIView

@property (strong, nonatomic)  UISlider *timeSlider; //进度条
@property (strong, nonatomic)  UILabel *totalTimeLabel; //总播放时间时间
@property (strong, nonatomic)  UILabel *currentTimeLabel; //当前播放时间

@end
