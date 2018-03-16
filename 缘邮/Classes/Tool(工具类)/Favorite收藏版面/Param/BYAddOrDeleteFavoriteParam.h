//
//  BYAddOrDeleteFavoriteParam.h
//  缘邮
//
//  Created by LiLu on 16/2/23.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYFavoriteParam.h"

@interface BYAddOrDeleteFavoriteParam : BYFavoriteParam
/**
 *  新的版面或自定义目录，版面为版面name，如Flash；
 */
@property (nonatomic, copy) NSString *name;
/**
 *  是否为自定义目录 0不是，1是
 */
@property (nonatomic, assign) int dir;

@end
