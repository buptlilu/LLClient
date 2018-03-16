//
//  BYMailTitleCell.m
//  缘邮
//
//  Created by LiLu on 16/2/19.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMailTitleCell.h"
#import "BYMail.h"
#import "BYUser.h"

#import "UIImageView+WebCache.h"
#import "NSDate+MJ.h"

@implementation BYMailTitleCell

- (void)setMail:(BYMail *)mail{
    _mail = mail;
    
    //头像
    [self.userIconImgView sd_setImageWithURL:[NSURL URLWithString:self.mail.user.face_url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //昵称
    self.userNameLabel.text = self.mail.user.BYid;
    
    if ([self.mail.user.gender isEqualToString:@"m"]) {
        self.userNameLabel.textColor = BYMaleNameColor;
    }else if ([self.mail.user.gender isEqualToString:@"f"]){
        self.userNameLabel.textColor = BYFemaleNameColor;
    }else if([self.mail.user.gender isEqualToString:@"n"]){
        self.userNameLabel.textColor = BYUnknownSexNameColor;
    }else{
        self.userNameLabel.textColor = BYUnknownSexNameColor;
    }
    
    //发信时间
    NSDate *postTime = [NSDate dateWithTimeIntervalSince1970:[self.mail.post_time longLongValue]];
    self.userMailSendTimeLabel.text = [postTime stringFromBYDate];
    
    //标题
    self.userMailTitleLabel.text = self.mail.title;
    
    if (self.mail.is_read) {
        //已读,颜色浅一点
        self.userMailTitleLabel.textColor = [UIColor lightGrayColor];
        self.userMailTitleLabel.font = [UIFont systemFontOfSize:14];
    } else {
        //未读,颜色深一点
        self.userMailTitleLabel.textColor = [UIColor blackColor];
        self.userMailTitleLabel.font = [UIFont systemFontOfSize:16];
    }
}

@end
