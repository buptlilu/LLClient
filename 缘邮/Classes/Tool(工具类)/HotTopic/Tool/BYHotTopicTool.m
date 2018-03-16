//
//  BYHotTopicTool.m
//  缘邮
//
//  Created by LiLu on 15/11/30.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYHotTopicTool.h"
#import "BYHotTopicParam.h"
#import "BYHttpTool.h"
#import "BYAccount.h"
#import "BYAccountTool.h"
#import "BYHotTopicResult.h"
#import "BYSectionHotParam.h"

#import "MJExtension.h"

@implementation BYHotTopicTool

+(void)loadHotTopicWhenSuccess:(void (^)(BYHotTopicResult *))success whenfailure:(void (^)(NSError *))failure{
    //创建一个参数模型
    BYHotTopicParam *param = [BYHotTopicParam param];
    NSString *urlStr = [NSString stringWithFormat:@"%@/widget/topten.json", BYBaseURL];
//    BYLog(@"%@", urlStr);
    [BYHttpTool GET:urlStr parameters:param.keyValues success:^(id responseObject) {
        //获取到版面列表数据
        BYHotTopicResult *result = [BYHotTopicResult objectWithKeyValues:responseObject];
        
        if (success) {
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)loadSectionTopicWithParam:(BYSectionHotParam *)param whenSuccess:(void (^)(BYHotTopicResult *))success whenFailure:(void (^)(NSError *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/widget/section-%@.json", BYBaseURL, param.name];
    [BYHttpTool GET:urlStr parameters:param.keyValues success:^(id responseObject) {
        //获取到版面列表数据
        BYHotTopicResult *result = [BYHotTopicResult objectWithKeyValues:responseObject];
        
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
