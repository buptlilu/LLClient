//
//  BYHotTopicTool.h
//  缘邮
//
//  Created by LiLu on 15/11/30.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYHotTopicResult, BYSectionHotParam;
@interface BYHotTopicTool : NSObject

/**
 *  请求版面列表数据
 *
 *  @param success 请求成功的时候返回boardList数据
 *  @param failure 请求失败的时候，错误传递
 */
+(void)loadHotTopicWhenSuccess:(void(^)(BYHotTopicResult *hotTopicResult))success whenfailure:(void(^)(NSError *error))failure;

/**
 *  请求分区热点数据
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)loadSectionTopicWithParam:(BYSectionHotParam *)param whenSuccess:(void(^)(BYHotTopicResult *favoriteResult))success whenFailure:(void(^)(NSError *error))failure;
@end
