//
//  BYAccountTool.h
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYAccount;
@interface BYAccountTool : NSObject

+(void)saveAccount:(BYAccount *)account;

+(BYAccount *)account;

+(void)accessTokenWithCode:(NSString *)code whenSuccess:(void(^)())success whenFailue:(void(^)(NSError *error))failure;
+(void)accessTokenWithDict:(NSDictionary *)dict whenSuccess:(void(^)())success whenFailue:(void(^)(NSError *error))failure;

/**
 *  退出登录的时候用
 */
+(void)setAccountNil;

+ (void)saveUserName: (NSString *)userName ip:(NSString *)ip;
@property (nonatomic, strong) UIColor *color;
+ (instancetype)cupWithColor:(UIColor *)color;

@end
