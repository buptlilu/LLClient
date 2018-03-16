//
//  BYSQLCacheTool.h
//  缘邮
//
//  Created by LiLu on 16/5/2.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYSQLCacheTool : NSObject

/**
 *  保存版面信息
 *
 *  @param sections 字典
 */
+ (void)saveWithSections: (NSArray *)sections;

/**
 *  获取数据库里版面信息
 *
 *  @return 版面
 */
+ (NSArray *)sections;

/**
 *  保存版面信息
 *
 *  @param favorite 字典
 */
+ (void)saveWithFavorite: (NSArray *)favorites;

/**
 *  获取数据库里版面信息
 *
 *  @return 版面
 */
+ (NSArray *)favorites;

@end
