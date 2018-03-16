//
//  BYCollectionTool.m
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYCollectionTool.h"
#import "BYHttpTool.h"
#import "BYArticle.h"
#import "BYAddCollectionParam.h"
#import "BYDeleteCollectionParam.h"
#import "BYCollectionListParam.h"
#import "BYCollectionListResult.h"

@implementation BYCollectionTool

+ (void)addArticleToCollectionWithParam:(BYAddCollectionParam *)param whenSuccess:(void (^)(BYArticle *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool POST:[NSString stringWithFormat:@"%@/collection/add.json", BYBaseURL] parameters:param.keyValues success:^(id responseObject) {
        
        //添加成功返回的结果
        BYArticle *article = [BYArticle objectWithKeyValues:responseObject];
        
//        BYLog(@"添加收录文章的回调:%@", responseObject);
        
        if (success) {
            success(article);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteArticleFromCollectionWithParam:(BYDeleteCollectionParam *)param whenSuccess:(void (^)(BYArticle *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool POST:[NSString stringWithFormat:@"%@/collection/delete.json", BYBaseURL] parameters:param.keyValues success:^(id responseObject) {
        
        //删除成功返回的结果
        BYArticle *article = [BYArticle objectWithKeyValues:responseObject];
        
        BYLog(@"删除收录文章的回调:%@", responseObject);
        
        if (success) {
            success(article);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)loadArticleFromCollectionWithParam:(BYCollectionListParam *)param whenSuccess:(void (^)(BYCollectionListResult *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/collection.json", BYBaseURL] parameters:param.keyValues success:^(id responseObject) {
        
        BYCollectionListResult *articleList = [BYCollectionListResult objectWithKeyValues:responseObject];
        
        //打印下看看
//        BYLog(@"%@====%@", articleList, responseObject);
        
        if (success) {
            success(articleList);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

@end
