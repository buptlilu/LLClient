//
//  BYBoardArticleTool.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBoardArticleTool.h"
#import "BYHttpTool.h"
#import "BYBoardArticleParam.h"
#import "BYSearchArticleParam.h"
#import "BYBoardArticleResult.h"
#import "BYSearchArticleResult.h"

@implementation BYBoardArticleTool
+(void)loadBoardArticleWithBoardArticleParam:(BYBoardArticleParam *)boardArticleParam whenSuccess:(void (^)(BYBoardArticleResult *))success whenfailure:(void (^)(NSError *))failure{
    
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/board/%@.json", BYBaseURL, boardArticleParam.name] parameters:boardArticleParam.keyValues success:^(id responseObject) {
        
        //解析数据
        BYBoardArticleResult *boardArticleResult = [BYBoardArticleResult objectWithKeyValues:responseObject];
        
        if (success) {
            success(boardArticleResult);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)searchArticleWithArticleParam:(BYSearchArticleParam *)param whenSuccess:(void (^)(BYSearchArticleResult *))success whenfailure:(void (^)(NSError *))failure{
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/search/threads.json", BYBaseURL] parameters:param.keyValues success:^(id responseObject) {
        
        //解析数据
        BYSearchArticleResult *articleResult = [BYSearchArticleResult objectWithKeyValues:responseObject];
        
        BYLog(@"===文章数据:%@", responseObject);
        
        if (success) {
            success(articleResult);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
// oauth_token=a9f493ad070c4c21c3f3d5131b7eb0d5
@end
