//
//  BYMailTool.h
//  缘邮
//
//  Created by LiLu on 16/2/18.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYMailResult, BYMailParam, BYMailDetailParam, BYMail, BYSendMailParam, BYSendMailResult, BYReplyMailParam, BYDeleteMailParam;
@interface BYMailTool : NSObject
/**
 *  获得邮件列表
 *
 *  @param param   参数
 *  @param success 成功
 *  @param failure 失败
 */
+(void)loadMailWithParam:(BYMailParam *)param whenSuccess:(void(^)(BYMailResult *mailResult))success whenFailure:(void(^)(NSError *error))failure;

/**
 *  获得一封邮件具体信息
 *
 *  @param param   参数
 *  @param success 成功
 *  @param failure 失败
 */
+(void)loadMailDetailWithParam:(BYMailDetailParam *)param whenSuccess:(void(^)(BYMail *mailDetail))success whenFailure:(void(^)(NSError *error))failure;

/**
 *  发送一封邮件
 *
 *  @param param   要发送的邮件参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)sendMailWithParam:(BYSendMailParam *)param whenSuccess:(void(^)(BYSendMailResult *sendMailResult))success whenFailure:(void(^)(NSError *error))failure;

/**
 *  回复一封邮件
 *
 *  @param param   要发送的邮件参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)replyMailWithParam:(BYReplyMailParam *)param whenSuccess:(void(^)(BYMail *replyMail))success whenFailure:(void(^)(NSError *error))failure;

/**
 *  删除一封邮件
 *
 *  @param param   要发送的邮件参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteMailWithParam:(BYDeleteMailParam *)param whenSuccess:(void(^)(BYMail *deleteMail))success whenFailure:(void(^)(NSError *error))failure;

@end
