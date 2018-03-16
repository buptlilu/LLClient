//
//  BYMeTool.h
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYMeResult;
@interface BYMeTool : NSObject
+(void)loadMeInfoWhenSuccess:(void(^)(BYMeResult *meInfo))success whenFailure:(void(^)(NSError *error))failure;

+(void)loadUserInfoWithUserId:(NSString *)userId whenSuccess:(void(^)(BYMeResult *userInfo))success whenFailure:(void(^)(NSError *error))failure;
@end
