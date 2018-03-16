//
//  BYMessageCell.m
//  缘邮
//
//  Created by LiLu on 16/2/22.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMessageCell.h"
#import "BYMessage.h"
#import "BYUser.h"

#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import "UIImageView+WebCache.h"
#import "NSDate+MJ.h"

@implementation BYMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(BYMessage *)message{
    _message = message;
    
    //头像
    [self.userIconImgView sd_setImageWithURL:[NSURL URLWithString:self.message.user.face_url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //昵称
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.message.user.BYid];
    
    if ([self.message.user.gender isEqualToString:@"m"]) {
        text.yy_color  = BYMaleNameColor;
    }else if ([self.message.user.gender isEqualToString:@"f"]){
        text.yy_color  = BYFemaleNameColor;
    }else if([self.message.user.gender isEqualToString:@"n"]){
        text.yy_color  = BYUnknownSexNameColor;
    }else{
        text.yy_color  = BYUnknownSexNameColor;
    }
    
    NSMutableAttributedString *text2 = [NSMutableAttributedString new];
    if ([self.message.type isEqualToString:@"at"]) {
        [text2 appendAttributedString:[[NSAttributedString alloc] initWithString:@" 在文章中提到了你" attributes:nil]];
    }else if ([self.message.type isEqualToString:@"reply"]){
        [text2 appendAttributedString:[[NSAttributedString alloc] initWithString:@" 在文章中回复了你" attributes:nil]];
    }else{
        [text2 appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:nil]];
    }
    text2.yy_color = [UIColor lightGrayColor];
    
    [text appendAttributedString:text2];
    text.yy_font = [UIFont systemFontOfSize:10];
    self.userNameLabel.backgroundColor = [UIColor whiteColor];
    self.userNameLabel.attributedText = text;
    
    //发信时间
    NSDate *postTime = [NSDate dateWithTimeIntervalSince1970:[self.message.time longLongValue]];
    self.userMessageTimeLabel.text = [postTime stringFromBYDate];
    
    //标题
    self.userMessageTitleLabel.text = self.message.title;
    
    if (self.message.is_read) {
        //已读,颜色浅一点
        self.userMessageTitleLabel.textColor = [UIColor lightGrayColor];
        self.userMessageTitleLabel.font = [UIFont systemFontOfSize:14];
    } else {
        //未读,颜色深一点
        self.userMessageTitleLabel.textColor = [UIColor blackColor];
        self.userMessageTitleLabel.font = [UIFont systemFontOfSize:16];
    }

}

@end
