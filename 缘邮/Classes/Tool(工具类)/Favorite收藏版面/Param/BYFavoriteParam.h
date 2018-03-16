//
//  BYFavoriteParam.h
//  缘邮
//
//  Created by LiLu on 15/12/14.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYFavoriteParam : BYBaseParam
//true	int	收藏夹层数，顶层为0
@property(nonatomic, assign) int level;
@end
