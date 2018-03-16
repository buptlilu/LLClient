//
//  BYAccountTool.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYAccountTool.h"
#import "BYAccount.h"
#import "BYAccountParam.h"
#import "BYHttpTool.h"

#import "MJExtension.h"

#define BYAccountFileName  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"account.data"]


@implementation BYAccountTool


+ (void)saveUserName:(NSString *)userName ip:(NSString *)ip{
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setValue:ip forKey:@"ip"];
}

//类方法一般用静态变量代替成员属性
static BYAccount *_account;

+ (void)setAccountNil{
    _account = nil;
    [self saveAccount:nil];
}

+(void)saveAccount:(BYAccount *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:BYAccountFileName];
//    BYLog(@"%@", BYAccountFileName);
}

+(BYAccount *)account{
    if (_account == nil) {
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:BYAccountFileName];
        
        //过期时间 = 当前保存时间 + 有效期
        //判断下账号是否过期，如果过期直接返回nil
        if ([[NSDate date] compare:_account.expires_date] != NSOrderedAscending) { //递增 小于 没有过期
            return nil;
        }
    }
    
    return _account;
}

+(void)accessTokenWithCode:(NSString *)code whenSuccess:(void (^)())success whenFailue:(void (^)(NSError *))failure{
    //参数模型
    BYAccountParam *param = [[BYAccountParam alloc] init];
    param.client_id = BYClient_id;
    param.client_secret = BYClient_secret;
    param.grant_type = BYGrant_type;
    param.code = code;
    param.redirect_uri = BYRedirect_uri;
    
    //发送post请求
    [BYHttpTool POST:@"http://bbs.byr.cn/oauth2/token"  parameters:param.keyValues success:^(id responseObject) {
        //字典转模型
        BYAccount *account = [BYAccount accountWithDict:responseObject];
        
        //保存账号信息:数据存储一般我们开发中会搞一个业务类，专门处理数据的存储
        //以后不想归档，用数据库，直接改业务类
        [BYAccountTool saveAccount:account];
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)accessTokenWithDict:(NSDictionary *)dict whenSuccess:(void(^)())success whenFailue:(void(^)(NSError *error))failure {
    NSString *access_token = dict[@"access_token"];
    if (access_token.length) {
        //字典转模型
        BYAccount *account = [BYAccount accountWithDict:dict];
        
        //保存账号信息:数据存储一般我们开发中会搞一个业务类，专门处理数据的存储
        //以后不想归档，用数据库，直接改业务类
        [BYAccountTool saveAccount:account];
        
        if (success) {
            success();
        }
    }else {
        if (failure) {
            failure(nil);
        }
    }
}
@end
