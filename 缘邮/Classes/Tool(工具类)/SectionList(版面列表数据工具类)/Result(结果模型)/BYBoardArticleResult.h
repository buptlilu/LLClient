//
//  BYBoardArticleResult.h
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBoard.h"
#import "BYPagination.h"
#import "BYArticle.h"
@class BYPagination, BYArticle;
@interface BYBoardArticleResult : BYBoard<MJKeyValue>

@property(nonatomic, strong) BYPagination *pagination;

@property(nonatomic, strong) NSMutableArray *article;

@end
