//
//  BYArticleTool.m
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYArticle.h"
#import "BYArticleParam.h"
#import "BYArticleResult.h"
#import "BYHttpTool.h"
#import "BYArticleTool.h"
#import "BYPostArticleParam.h"
#import "BYReplyMsgParam.h"
#import "BYSearchArticleParam.h"
#import "BYLikeParam.h"
#import "BYArticleLikeResult.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"

@implementation BYArticleTool
+(void)loadArticleWithArticleParam:(BYArticleParam *)articleParam whenSuccess:(void (^)(BYArticleResult *))success whenfailure:(void (^)(NSError *))failure{
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/threads/%@/%d.json", BYBaseURL, articleParam.name, articleParam.BYid] parameters:articleParam.keyValues success:^(id responseObject) {
        
        //解析数据
        BYArticleResult *articleResult = [BYArticleResult objectWithKeyValues:responseObject];
        
//        BYLog(@"%@===文章数据:%@", articleParam.oauth_token, responseObject);
        
        if (success) {
            success(articleResult);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)postArticleWithArticleParam:(BYPostArticleParam *)param whenSuccess:(void (^)(BYArticle *))success whenfailure:(void (^)(NSError *))failure{
    [BYHttpTool POST:[NSString stringWithFormat:@"%@/article/%@/post.json", BYBaseURL, param.name] parameters:param.keyValues success:^(id responseObject) {
        
        //解析数据
        BYArticle *article = [BYArticle objectWithKeyValues:responseObject];
        
        
        //        BYLog(@"%@===文章数据:%@", articleParam.oauth_token, responseObject);
        
        if (success) {
            success(article);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)replyMsgWithArticleParam:(BYReplyMsgParam *)param whenSuccess:(void (^)(BYArticle *))success whenfailure:(void (^)(NSError *))failure{
    [BYHttpTool POST:[NSString stringWithFormat:@"%@/article/%@/post.json", BYBaseURL, param.name] parameters:param.keyValues success:^(id responseObject) {
        
        //解析数据
        BYArticle *article = [BYArticle objectWithKeyValues:responseObject];
        
        
        //        BYLog(@"%@===文章数据:%@", articleParam.oauth_token, responseObject);
        
        if (success) {
            success(article);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)likeArticleWithArticleParam:(BYLikeParam *)param whenSuccess:(void(^)(BYArticleLikeResult *result))success whenfailure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/article/%@/like/%d.json", BYBaseURL, param.name, param.id];
    NSLog(@"urlStr:%@", urlStr);
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer= [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer= [AFHTTPResponseSerializer serializer];
    
    [mgr POST:urlStr parameters:param.keyValues success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        BYLog(@"%@", string);
        BYLog(@"%@", responseObject);
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        BYArticleLikeResult *articleLikeResult = [BYArticleLikeResult objectWithKeyValues:responseDic];
        if (success) {
            success(articleLikeResult);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        @try {
            NSError *error2 = nil;
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:&error2];
            BYArticleLikeResult *articleLikeResult = [BYArticleLikeResult objectWithKeyValues:responseDic];
            if (error2) {
                if (failure) {
                    failure(error);
                }
            }else {
                if (articleLikeResult.msg) {
                    [MBProgressHUD showSuccess:articleLikeResult.msg];
                }
            }
        } @catch (NSException *exception) {
            if (failure) {
                failure(error);
            }
        } @finally {
            
        }
        
    }];
}
@end
