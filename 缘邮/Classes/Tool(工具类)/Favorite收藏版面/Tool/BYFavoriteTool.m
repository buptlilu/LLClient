//
//  BYFavoriteTool.m
//  缘邮
//
//  Created by LiLu on 15/12/14.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYFavoriteTool.h"
#import "BYHttpTool.h"
#import "BYAddOrDeleteFavoriteParam.h"
#import "BYFavoriteResult.h"
#import "BYSQLCacheTool.h"

#import "MJExtension.h"

@implementation BYFavoriteTool
+(void)loadFavoriteListForRefreshing:(BOOL)flag whenSuccess:(void (^)(NSArray *))success whenFailure:(void (^)(NSError *))failure{
    if (!flag) {
        //先从数据库里取数据
        NSArray *favorites = [BYSQLCacheTool favorites];
        
        //如果从数据库里取的值有数据,就直接回去
        if (favorites.count) {
            if (success) {
                success(favorites);
                BYLog(@"没有消耗流量");
            }
            return;
        }
    }
    
    //创建一个参数
    BYFavoriteParam *param = [BYFavoriteParam param];
    param.level = 0;
    
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/favorite/%d.json", BYBaseURL, param.level] parameters:param.keyValues success:^(id responseObject) {
        BYLog(@"消耗流量");
        //获取收藏版面的信息
        BYFavoriteResult *result = [BYFavoriteResult objectWithKeyValues:responseObject];
        BYLog(@"收藏版面信息:%@", responseObject);
        if (success) {
            success(result.board);
        }
        //从网络获取的,就保存到数据库里
        [BYSQLCacheTool saveWithFavorite:responseObject[@"board"]];
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)addFavoriteBoardWithParam:(BYAddOrDeleteFavoriteParam *)param whenSuccess:(void (^)(BYFavoriteResult *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool POST:[NSString stringWithFormat:@"%@/favorite/add/%d.json", BYBaseURL, param.level] parameters:param.keyValues success:^(id responseObject) {
        
        //添加成功返回的结果
        BYFavoriteResult *result = [BYFavoriteResult objectWithKeyValues:responseObject];
        
//        BYLog(@"添加收藏的回调:%@", responseObject);
        
        if (success) {
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteFavoriteBoardWithParam:(BYAddOrDeleteFavoriteParam *)param whenSuccess:(void (^)(BYFavoriteResult *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool POST:[NSString stringWithFormat:@"%@/favorite/delete/%d.json", BYBaseURL, param.level] parameters:param.keyValues success:^(id responseObject) {
        
        //添加成功返回的结果
        BYFavoriteResult *result = [BYFavoriteResult objectWithKeyValues:responseObject];
        
//        BYLog(@"添加收藏的回调:%@", responseObject);
        
        if (success) {
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
