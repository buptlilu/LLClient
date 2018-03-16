//
//  BYMessageCell.h
//  缘邮
//
//  Created by LiLu on 16/2/22.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYLabel, BYMessage;
@interface BYMessageCell : UITableViewCell

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *userIconImgView;

/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet YYLabel *userNameLabel;

/**
 *  消息标题
 */
@property (weak, nonatomic) IBOutlet UILabel *userMessageTitleLabel;

/**
 *  消息发送时间
 */
@property (weak, nonatomic) IBOutlet UILabel *userMessageTimeLabel;

/**
 *  cell模型
 */
@property (nonatomic, strong) BYMessage *message;
@end
