//
//  BYArticleResult.h
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYArticle.h"
#import "BYPagination.h"

@interface BYArticleResult : BYArticle<MJKeyValue>

@property(nonatomic, assign) BOOL collect;

/**
 *  精彩回复
 */
@property(nonatomic, strong) NSMutableArray *like_articles;

/**
 *  分页情况
 */
@property(nonatomic, strong) BYPagination *pagination;

/**
 *  文章及评论情况，第一个是楼主文章，下面是评论回复
 */
@property(nonatomic, strong) NSMutableArray *article;
@end
