//
//  BYBoardArticleParam.h
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYBoardArticleParam : BYBaseParam
/**
 *  合法的版面的名称
 */
@property(nonatomic, copy) NSString *name;
/**
 *  
 int 最小0 最大6 默认2
 表示版面文章列表的模式，分别是
 = 0 以id为顺序列表
 = 1 文摘区列表
 = 2 同主题(web顺序)列表
 = 3 精华区列表
 = 4 回收站列表
 = 5 废纸篓列表
 = 6 同主题(发表顺序)列表
 */
@property(nonatomic, assign) int mode;
/**
 *  每页文章的数量,int 最小1 最大50 默认30
 */
@property(nonatomic, assign) int count;
/**
 *  文章的页数,int 默认1
 */
@property(nonatomic, assign) int page;
@end
