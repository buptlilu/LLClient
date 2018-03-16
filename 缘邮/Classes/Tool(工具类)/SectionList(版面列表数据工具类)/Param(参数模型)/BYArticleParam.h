//
//  BYArticleParam.h
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYArticleParam : BYBaseParam
/**
 *  true	string	合法的版面名称
 */
@property(nonatomic, copy) NSString *name;
/**
 *  id	true	int	文章或主题id
 */
@property(nonatomic, assign) int BYid;

/**
 *  string	只显示该主题中某一用户的文章，au为该用户的用户名（id），大小写敏感
 */
@property(nonatomic, copy) NSString *au;
/**
 *  int 最小1 最大50 默认10	每页文章的数量
 */
@property(nonatomic, assign) int count;
/**
 *  int 默认1	主题文章的页数
 */
@property(nonatomic, assign) int page;
@end
/*
 :name	true	string	合法的版面名称
 :id	true	int	文章或主题id
 au	false	string	只显示该主题中某一用户的文章，au为该用户的用户名，大小写敏感
 count	false	int 最小1 最大50 默认10	每页文章的数量
 page	false	int 默认1	主题文章的页数
 */
