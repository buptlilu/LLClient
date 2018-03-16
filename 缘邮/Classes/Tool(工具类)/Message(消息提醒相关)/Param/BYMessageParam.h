//
//  BYMessageParam.h
//  缘邮
//
//  Created by LiLu on 16/2/22.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYMessageParam : BYBaseParam

/**
 *  只能为at|reply中的一个，分别是@我的文章和回复我的文章
 */
@property (nonatomic, copy) NSString *type;

/**
 *  每页提醒文章的数量
 */
@property (nonatomic, assign) int count;

/**
 *  提醒列表的页数
 */
@property (nonatomic, assign) int page;

@end
