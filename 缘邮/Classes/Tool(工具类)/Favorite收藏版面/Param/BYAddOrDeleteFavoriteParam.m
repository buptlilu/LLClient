//
//  BYAddOrDeleteFavoriteParam.m
//  缘邮
//
//  Created by LiLu on 16/2/23.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYAddOrDeleteFavoriteParam.h"

@implementation BYAddOrDeleteFavoriteParam

+ (instancetype)param{
    BYAddOrDeleteFavoriteParam *param = [super param];
    param.level = 0;
    param.dir = 0;
    return param;
}

@end
