//
//  BYFavoriteResult.h
//  缘邮
//
//  Created by LiLu on 15/12/14.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "BYFavorite.h"

@interface BYFavoriteResult : NSObject<MJKeyValue>
/**
 *  该层收藏夹包含的自定义目录的数组，数组元素为收藏夹元数据
 */
@property(nonatomic, strong) NSArray *sub_favorite;
/**
 *  该层收藏夹包含的分区的数组，数组元素为分区元数据
 */
@property(nonatomic, strong) NSArray *section;
/**
 *  该层收藏夹包含的版面的数组，数组元素为版面元数据
 */
@property(nonatomic, strong) NSArray *board;

@end
