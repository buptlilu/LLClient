//
//  BYFavoriteTool.h
//  缘邮
//
//  Created by LiLu on 15/12/14.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYFavoriteParam, BYFavoriteResult, BYAddOrDeleteFavoriteParam;
@interface BYFavoriteTool : NSObject

+(void)loadFavoriteListForRefreshing:(BOOL)flag whenSuccess:(void(^)(NSArray *favorites))success whenFailure:(void(^)(NSError *error))failure;

/**
 *  添加收藏
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addFavoriteBoardWithParam:(BYAddOrDeleteFavoriteParam *)param whenSuccess:(void(^)(BYFavoriteResult *favoriteResult))success whenFailure:(void(^)(NSError *error))failure;

/**
 *  取消收藏
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteFavoriteBoardWithParam:(BYAddOrDeleteFavoriteParam *)param whenSuccess:(void(^)(BYFavoriteResult *favoriteResult))success whenFailure:(void(^)(NSError *error))failure;

@end
