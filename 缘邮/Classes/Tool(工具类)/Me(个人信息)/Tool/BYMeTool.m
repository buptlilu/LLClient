//
//  BYMeTool.m
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMeTool.h"
#import "BYHttpTool.h"
#import "BYBaseParam.h"
#import "BYMeResult.h"

@implementation BYMeTool

+(void)loadMeInfoWhenSuccess:(void (^)(BYMeResult *))success whenFailure:(void (^)(NSError *))failure{
    BYBaseParam *param = [BYBaseParam param];
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/user/getinfo.json", BYBaseURL] parameters:param.keyValues success:^(id responseObject) {
        //获取到用户信息
        BYMeResult *result = [BYMeResult objectWithKeyValues:responseObject];
//        NSLog(@"%@", responseObject);
        if (success) {
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)loadUserInfoWithUserId:(NSString *)userId whenSuccess:(void (^)(BYMeResult *))success whenFailure:(void (^)(NSError *))failure{
    BYBaseParam *param = [BYBaseParam param];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/query/%@.json", BYBaseURL, userId];
    urlStr = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                     (CFStringRef)urlStr,
                                                     (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                     NULL,
                                                     kCFStringEncodingUTF8));
    
//    BYLog(@"%@", urlStr);
    
    [BYHttpTool GET:urlStr parameters:param.keyValues success:^(id responseObject) {
        //获取到用户信息
        BYMeResult *result = [BYMeResult objectWithKeyValues:responseObject];
//        NSLog(@"%@", responseObject);
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
