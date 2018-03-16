//
//  BYMessageTool.m
//  缘邮
//
//  Created by LiLu on 16/2/22.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMessageTool.h"
#import "BYMessageParam.h"
#import "BYMessageResult.h"
#import "BYHttpTool.h"
#import "BYMsgDetailParam.h"
#import "BYArticle.h"
#import "BYSetMsgReadParam.h"
#import "BYNewCountResult.h"

@implementation BYMessageTool

+ (void)loadMessageWithParam:(BYMessageParam *)param whenSuccess:(void (^)(BYMessageResult *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/refer/%@.json", BYBaseURL, param.type] parameters:param.keyValues success:^(id responseObject) {
        
        BYMessageResult *msgResult = [BYMessageResult objectWithKeyValues:responseObject];
        
        //打印下看看
//        BYLog(@"%@====%@", msgResult, responseObject);
        
        if (success) {
            success(msgResult);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)loadMsgDetailWithParam:(BYMsgDetailParam *)param whenSuccess:(void (^)(BYArticle *))success whenFailure:(void (^)(NSError *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/article/%@/%d.json", BYBaseURL, param.name, param.BYid];
//    BYLog(@"%@====", urlStr);
    [BYHttpTool GET:urlStr parameters:param.keyValues success:^(id responseObject) {
        
        BYArticle *msgResult = [BYArticle objectWithKeyValues:responseObject];
        
        //打印下看看
//        BYLog(@"%@====%@", @"具体消息:", responseObject);
        
        if (success) {
            success(msgResult);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//设置为已读
+ (void)setMsgReadWithParam:(BYSetMsgReadParam *)param whenSuccess:(void (^)(BYArticle *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool POST:[NSString stringWithFormat:@"%@/refer/%@/setRead/%d.json", BYBaseURL, param.type, param.index] parameters:param.keyValues success:^(id responseObject) {
        BYArticle *msgResult = [BYArticle objectWithKeyValues:responseObject];

//        BYLog(@"%@====%@", @"具体消息:", responseObject);
        
        if (success) {
            success(msgResult);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteMsgWithParam:(BYSetMsgReadParam *)param whenSuccess:(void (^)(BYArticle *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool POST:[NSString stringWithFormat:@"%@/refer/%@/delete/%d.json", BYBaseURL, param.type, param.index] parameters:param.keyValues success:^(id responseObject) {
        BYArticle *msgResult = [BYArticle objectWithKeyValues:responseObject];
        
        //        BYLog(@"%@====%@", @"具体消息:", responseObject);
        
        if (success) {
            success(msgResult);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)loadNewAtMeMsgCountWhenSuccess:(void (^)(BYNewCountResult *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/refer/at/info.json", BYBaseURL] parameters:[BYBaseParam param].keyValues success:^(id responseObject) {
        BYNewCountResult *newCountResult = [BYNewCountResult objectWithKeyValues:responseObject];
        
        //        BYLog(@"%@====%@", @"具体消息:", responseObject);
        
        if (success) {
            success(newCountResult);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)loadNewReplyMeMsgCountWhenSuccess:(void (^)(BYNewCountResult *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/refer/reply/info.json", BYBaseURL] parameters:[BYBaseParam param].keyValues success:^(id responseObject) {
        BYNewCountResult *newCountResult = [BYNewCountResult objectWithKeyValues:responseObject];
        
        //        BYLog(@"%@====%@", @"具体消息:", responseObject);
        
        if (success) {
            success(newCountResult);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
