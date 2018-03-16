//
//  BYMail.h
//  缘邮
//
//  Created by LiLu on 16/2/18.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYUser, BYAttachment;
@interface BYMail : NSObject

/**
 *  信件编号，此编号为/mail/:box/:num中的num
 */
@property (nonatomic, assign) int index;

/**
 *  是否标记为m
 */
@property (nonatomic, assign) BOOL is_m;

/**
 *  是否已读
 */
@property (nonatomic, assign) BOOL is_read;

/**
 *  是否回复
 */
@property (nonatomic, assign) BOOL is_reply;

/**
 *  是否有附近
 */
@property (nonatomic, assign) BOOL has_attachment;

/**
 *  信件标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  发信人，此为user元数据，如果user不存在则为用户id  user|string
 */
@property (nonatomic, strong) BYUser *user;

/**
 *  发信时间
 */
@property (nonatomic, copy) NSString *post_time;

/**
 *  所属信箱名
 */
@property (nonatomic, copy) NSString *box_name;

/**
 *  信件内容	只存在于/mail/:box/:num中
 */
@property (nonatomic, copy) NSString *content;

/**
 *  信件的附件列表
 */
@property (nonatomic, strong) BYAttachment *attachment;

@end
