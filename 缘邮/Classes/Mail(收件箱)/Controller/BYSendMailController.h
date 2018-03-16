//
//  BYSendMailController.h
//  缘邮
//
//  Created by LiLu on 16/2/19.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYSendMailParam;
@interface BYSendMailController : DKViewController

@property (nonatomic, copy) NSString *sendUserId;

/**
 *  发送邮件需要的参数
 */
@property (nonatomic, strong) BYSendMailParam *param;

@end
