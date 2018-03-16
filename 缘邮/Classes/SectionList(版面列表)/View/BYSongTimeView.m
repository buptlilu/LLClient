//
//  BYSongTimeView.m
//  缘邮
//
//  Created by LiLu on 16/3/1.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYSongTimeView.h"

@implementation BYSongTimeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor darkGrayColor];
        [self setUpAllChildView];
//        self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)setUpAllChildView{
    //总时间
    UILabel *totalTimeLabel = [[UILabel alloc] init];
    totalTimeLabel.font = [UIFont systemFontOfSize:12];
    totalTimeLabel.textColor = [UIColor whiteColor];
    totalTimeLabel.text = @"00:00";
    [self addSubview:totalTimeLabel];
    _totalTimeLabel = totalTimeLabel;
    
    //当前时间
    UILabel *currentTimeLabel = [[UILabel alloc] init];
    currentTimeLabel.font = [UIFont systemFontOfSize:12];
    currentTimeLabel.textColor = [UIColor whiteColor];
    currentTimeLabel.text = @"00:00";
    [self addSubview:currentTimeLabel];
    _currentTimeLabel = currentTimeLabel;
    
    //进度条
    UISlider *timeSlider = [[UISlider alloc] init];
    [timeSlider setThumbImage:[UIImage imageNamed:@"playbar_slider_thumb"] forState:UIControlStateNormal];
    timeSlider.maximumValue = 200;
    timeSlider.value = 100;
    [self addSubview:timeSlider];
    _timeSlider = timeSlider;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat timeLabelW = 35;
    CGFloat timeLabelH = 14.5;
    self.totalTimeLabel.frame = CGRectMake(5, 3, timeLabelW, timeLabelH);
    self.currentTimeLabel.frame = CGRectMake(self.bounds.size.width - timeLabelW - 5, 3, timeLabelW, timeLabelH);
    
    CGFloat sliderX = CGRectGetMaxX(self.totalTimeLabel.frame) + 3;
    CGFloat sliderY = -5;
    CGFloat sliderW = self.bounds.size.width - 2 * (timeLabelW + 5 + 3);
    CGFloat sliderH = 31;
    self.timeSlider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
}

@end
