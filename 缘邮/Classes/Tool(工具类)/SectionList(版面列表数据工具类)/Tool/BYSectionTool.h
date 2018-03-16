//
//  BYBoardListTool.h
//  缘邮
//
//  Created by LiLu on 15/11/29.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYSectionTool : NSObject

/**
 *  请求版面列表数据
 *
 *  @param success 请求成功的时候返回boardList数据
 *  @param failure 请求失败的时候，错误传递
 */
+(void)loadSectionListForRefreshing:(BOOL) flag whenSuccess:(void(^)(NSArray *sections))success whenfailure:(void(^)(NSError *error))failure;

@end
