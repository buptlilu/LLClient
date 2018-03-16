//
//  BYCollectionListParam.h
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYCollectionListParam : BYBaseParam

/**
 *  int 默认1	列表的页数
 */
@property (nonatomic, assign) int page;

/**
 *  int 最小1 最大50 默认30	每页收录主题的数量
 */
@property (nonatomic, assign) int count;

@end
