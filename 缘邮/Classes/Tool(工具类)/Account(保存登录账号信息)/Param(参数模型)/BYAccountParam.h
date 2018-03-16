//
//  BYAccountParam.h
//  缘邮
//
//  Created by LiLu on 15/11/29.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 请求地址 http://bbs.byr.cn/oauth2/token
 
 请求方式 POST
 
 请求参数
 参数	必选	含义
 client_id	true	开发者申请通过后分配的id,对应于appkey
 client_secret	true	开发者申请通过后得到的秘钥
 redirect_uri	true	与上面一步中传入的redirect_uri保持一致
 grant_type	true	授权类型，此处为 "authorization_code"
 code	true	上一步返回的authorization code。code 在10分钟后过期
 */
@interface BYAccountParam : NSObject

/**
 *  开发者申请通过后分配的id,对应于appkey
 */
@property(nonatomic, copy) NSString *client_id;

/**
 *  开发者申请通过后得到的秘钥
 */
@property(nonatomic, copy) NSString *client_secret;

/**
 *  与上面一步中传入的redirect_uri保持一致
 */
@property(nonatomic, copy) NSString *redirect_uri;

/**
 *  授权类型，此处为 "authorization_code"
 */
@property(nonatomic, copy) NSString *grant_type;

/**
 *  上一步返回的authorization code。code 在10分钟后过期
 */
@property(nonatomic, copy) NSString *code;

@end
