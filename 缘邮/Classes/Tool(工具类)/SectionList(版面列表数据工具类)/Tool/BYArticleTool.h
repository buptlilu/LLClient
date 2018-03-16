//
//  BYArticleTool.h
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYArticleParam, BYPostArticleParam, BYArticleResult, BYReplyMsgParam, BYArticle, BYLikeParam, BYArticleLikeResult;
@interface BYArticleTool : NSObject
+(void)loadArticleWithArticleParam:(BYArticleParam *)articleParam whenSuccess:(void(^)(BYArticleResult *articleResult))success whenfailure:(void(^)(NSError *error))failure;

/**
 *  发表新文章
 *
 *  @param param 参数
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+(void)postArticleWithArticleParam:(BYPostArticleParam *)param whenSuccess:(void(^)(BYArticle *article))success whenfailure:(void(^)(NSError *error))failure;

/**
 *  发表新文章
 *
 *  @param param 参数
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+(void)replyMsgWithArticleParam:(BYReplyMsgParam *)param whenSuccess:(void(^)(BYArticle *article))success whenfailure:(void(^)(NSError *error))failure;

/**
 *  为文章点赞
 *
 *  @param param   将要点赞的文章信息
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)likeArticleWithArticleParam:(BYLikeParam *)param whenSuccess:(void(^)(BYArticleLikeResult *result))success whenfailure:(void(^)(NSError *error))failure;

@end
