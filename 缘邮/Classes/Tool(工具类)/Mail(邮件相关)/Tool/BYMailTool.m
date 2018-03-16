//
//  BYMailTool.m
//  缘邮
//
//  Created by LiLu on 16/2/18.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMailTool.h"
#import "BYHttpTool.h"
#import "BYMailParam.h"
#import "BYMailResult.h"
#import "BYMail.h"
#import "BYMailDetailParam.h"
#import "BYSendMailParam.h"
#import "BYSendMailResult.h"
#import "BYReplyMailParam.h"
#import "BYDeleteMailParam.h"

@implementation BYMailTool

+ (void)loadMailWithParam:(BYMailParam *)param whenSuccess:(void (^)(BYMailResult *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/mail/%@.json", BYBaseURL, param.box] parameters:param.keyValues success:^(id responseObject) {
        
        BYMailResult *mailResult = [BYMailResult objectWithKeyValues:responseObject];
        
        //打印下看看
        //BYLog(@"%@====%@", mailResult, responseObject);
        
        if (success) {
            success(mailResult);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)loadMailDetailWithParam:(BYMailDetailParam *)param whenSuccess:(void (^)(BYMail *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/mail/%@/%d.json", BYBaseURL, param.box, param.num] parameters:param.keyValues success:^(id responseObject) {
        
        BYMail *mailDetail = [BYMail objectWithKeyValues:responseObject];
        
        //打印下看看
//        BYLog(@"%@====%@", mailDetail, responseObject);
        
        if (success) {
            success(mailDetail);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)sendMailWithParam:(BYSendMailParam *)param whenSuccess:(void (^)(BYSendMailResult *))success whenFailure:(void (^)(NSError *))failure{
    
    [BYHttpTool POST:[NSString stringWithFormat:@"%@/mail/send.json", BYBaseURL] parameters:param.keyValues success:^(id responseObject) {
//        BYLog(@"参数%@响应结果:%@", param.keyValues, responseObject);
        
        BYSendMailResult *sendMailResult = [BYSendMailResult objectWithKeyValues:responseObject];
        
        if (success) {
            success(sendMailResult);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)replyMailWithParam:(BYReplyMailParam *)param whenSuccess:(void (^)(BYMail *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool POST:[NSString stringWithFormat:@"%@/mail/%@/reply/%d.json", BYBaseURL, param.box, param.num] parameters:param.keyValues success:^(id responseObject) {
//        BYLog(@"参数%@响应结果:%@", param.keyValues, responseObject);
        
        BYMail *replyMail = [BYMail objectWithKeyValues:responseObject];
        
//        BYLog(@"返回的结果为:%@", replyMail.description);
        
        if (success) {
            success(replyMail);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteMailWithParam:(BYDeleteMailParam *)param whenSuccess:(void (^)(BYMail *))success whenFailure:(void (^)(NSError *))failure{
    [BYHttpTool POST:[NSString stringWithFormat:@"%@/mail/%@/delete/%d.json", BYBaseURL, param.box, param.num] parameters:param.keyValues success:^(id responseObject) {
//        BYLog(@"参数%@响应结果:%@", param.keyValues, responseObject);
        
        BYMail *deleteMail = [BYMail objectWithKeyValues:responseObject];
        
        if (success) {
            success(deleteMail);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
