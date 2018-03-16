//
//  BYCollectionTool.h
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYArticle, BYAddCollectionParam, BYDeleteCollectionParam, BYCollectionListParam, BYCollectionListResult;
@interface BYCollectionTool : NSObject

/**
 *  添加主题至收录
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addArticleToCollectionWithParam:(BYAddCollectionParam *)param whenSuccess:(void(^)(BYArticle *article))success whenFailure:(void(^)(NSError *error))failure;

/**
 *  删指定收录文章
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteArticleFromCollectionWithParam:(BYDeleteCollectionParam *)param whenSuccess:(void(^)(BYArticle *article))success whenFailure:(void(^)(NSError *error))failure;

/**
 *  用户收录文章列表
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)loadArticleFromCollectionWithParam:(BYCollectionListParam *)param whenSuccess:(void(^)(BYCollectionListResult *articleList))success whenFailure:(void(^)(NSError *error))failure;

@end
