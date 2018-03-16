//
//  BYSearchArticleParam.h
//  缘邮
//
//  Created by LiLu on 16/3/2.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYSearchArticleParam : BYBaseParam
/**
 *  单个合法版面
 */
@property(nonatomic, copy) NSString *board;
/**
 *  文章标题包含此关键词
 */
@property(nonatomic, copy) NSString *title1;
/**
 *  文章标题同时包含此关键词
 */
@property(nonatomic, copy) NSString *title2;
/**
 *  文章标题不包含此关键词
 */
@property(nonatomic, copy) NSString *titlen;
/**
 *  文章的作者
 */
@property(nonatomic, copy) NSString *author;
/**
 *  搜索距今多少天内的文章
 */
@property(nonatomic, assign) int day;
/**
 *  文章是否含有m标记 含有为1
 */
@property(nonatomic, assign) int m;
/**
 *  文章是否含有附件 含有为1
 */
@property(nonatomic, assign) int a;
/**
 *  每页文章的数量
 */
@property(nonatomic, assign) int count;
/**
 *  文章的页数
 */
@property(nonatomic, assign) int page;
@end
