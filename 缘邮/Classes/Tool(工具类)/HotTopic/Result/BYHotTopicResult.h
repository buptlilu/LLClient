//
//  BYHotTopicResult.h
//  缘邮
//
//  Created by LiLu on 15/11/30.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYArticle.h"

#import "MJExtension.h"

@interface BYHotTopicResult : NSObject<MJKeyValue>

/**
 *  十大热门话题所包含的文章元数据数组，对于每个文章元数据存在一个新的属性id_count表示十大的数量
 */
@property(nonatomic, strong) NSArray *article;

/**
 *  widget标识
 */
@property(nonatomic, copy) NSString *name;

/**
 *  widget标题
 */
@property(nonatomic, copy) NSString *title;

/**
 *  上次修改时间
 */
@property(nonatomic, assign) int time;

@end

/*
 
 widget元数据，以及在元数据含有以下属性
 
 属性	类型	说明
 article	array	十大热门话题所包含的文章元数据数组，对于每个文章元数据存在一个新的属性id_count表示十大的数量
 
 
 widget元数据
 属性	类型	说明	存在条件
 name	string	widget标识
 title	string	widget标题
 time	int	上次修改时间
 */
