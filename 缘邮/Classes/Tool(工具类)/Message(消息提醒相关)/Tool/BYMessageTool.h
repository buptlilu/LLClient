//
//  BYMessageTool.h
//  缘邮
//
//  Created by LiLu on 16/2/22.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@class BYMessageParam, BYMessageResult, BYMsgDetailParam, BYArticle, BYSetMsgReadParam, BYNewCountResult;
@interface BYMessageTool : BYBaseParam

/**
 *  获取回复我的文章或者@我的文章的消息列表
 *
 *  @param param   获得消息列表需要的参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)loadMessageWithParam:(BYMessageParam *)param whenSuccess:(void(^)(BYMessageResult *msgDetail))success whenFailure:(void(^)(NSError *error))failure;

+ (void)loadMsgDetailWithParam:(BYMsgDetailParam *)param whenSuccess:(void(^)(BYArticle *msgDetail))success whenFailure:(void(^)(NSError *error))failure;

+ (void)setMsgReadWithParam:(BYSetMsgReadParam *)param whenSuccess:(void(^)(BYArticle *msg))success whenFailure:(void(^)(NSError *error))failure;

+ (void)deleteMsgWithParam:(BYSetMsgReadParam *)param whenSuccess:(void(^)(BYArticle *msg))success whenFailure:(void(^)(NSError *error))failure;

//获取提醒At我的文章提醒数
+ (void)loadNewAtMeMsgCountWhenSuccess:(void(^)(BYNewCountResult *newCountResult))success whenFailure:(void(^)(NSError *error))failure;

//获取回复我的文章提醒数
+ (void)loadNewReplyMeMsgCountWhenSuccess:(void(^)(BYNewCountResult *newCountResult))success whenFailure:(void(^)(NSError *error))failure;

@end
