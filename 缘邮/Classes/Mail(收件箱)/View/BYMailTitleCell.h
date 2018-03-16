//
//  BYMailTitleCell.h
//  缘邮
//
//  Created by LiLu on 16/2/19.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYMail;

@interface BYMailTitleCell : UITableViewCell

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *userIconImgView;

/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

/**
 *  邮件标题
 */
@property (weak, nonatomic) IBOutlet UILabel *userMailTitleLabel;

/**
 *  邮件发送时间
 */
@property (weak, nonatomic) IBOutlet UILabel *userMailSendTimeLabel;

/**
 *  cell的模型
 */

@property (nonatomic, strong) BYMail *mail;
@end
