//
//  BYFavorite.h
//  缘邮
//
//  Created by LiLu on 15/12/14.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYFavorite : NSObject
/**
 *  版面名称
 */
@property(nonatomic, copy) NSString *name;
/**
 *  版主列表，以空格分隔各个id
 */
@property(nonatomic, copy) NSString *manager;
/**
 *  版面描述
 */
@property(nonatomic, copy) NSString *BYdescription;
/**
 *  版面所属类别
 */
@property(nonatomic, copy) NSString *BYclass;
/**
 *  版面所属分区号
 */
@property(nonatomic, copy) NSString *section;
/**
 *  今日主题总数(收藏夹接口)
 */
@property(nonatomic, assign) int threads_today_count;
@end
