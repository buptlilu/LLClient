//
//  BYNewFeatureCell.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYNewFeatureCell.h"
#import "BYMainTabBarController.h"
#import "BYRootTool.h"

@interface BYNewFeatureCell ()

@property(nonatomic, weak) UIImageView *imageView;

@property(nonatomic, weak) UIButton *startButton;

@end

@implementation BYNewFeatureCell


-(UIButton *)startButton{
    if (!_startButton) {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setTitle:@"进入缘邮" forState:UIControlStateNormal];
        [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [startBtn setBackgroundColor:[UIColor orangeColor]];
//        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
//        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
        [startBtn sizeToFit];
        [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        
        _startButton = startBtn;
    }
    return _startButton;
}


-(UIImageView *)imageView{
    if (!_imageView) {
        UIImageView *imageV = [[UIImageView alloc] init];
        _imageView = imageV;
        
        //注意一定要添加到contentView上
        [self.contentView addSubview:imageV];
    }
    return _imageView;
}

-(void)layoutSubviews{
    self.imageView.frame = self.bounds;
    
    //开始按钮
    self.startButton.center = CGPointMake(self.width * 0.5, self.height - 35);
}

//判断当前cell是否是最后一页
-(void)setIndexPath:(NSIndexPath *)indexPath count:(int)count{
    if (indexPath.row == count - 1) { //最后一页，显示分享和开始按钮
        self.startButton.hidden = NO;
    }else{//非最后一页，隐藏分享和开始按钮
        self.startButton.hidden = YES;
    }
}

//点击进入缘邮的时候调用
-(void)start{
    //进入tabBarVc
//    BYMainTabBarController *tabBarVc = [[BYMainTabBarController alloc] init];
    
    //切换根控制器
//    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
    [BYRootTool chooseRootViewController:[UIApplication sharedApplication].keyWindow];
}


-(void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}
@end
