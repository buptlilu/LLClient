//
//  BYCollectionListResult.h
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYPagination;
@interface BYCollectionListResult : NSObject

/**
 *  收录文章列表分页信息
 */
@property (nonatomic, strong) BYPagination *pagination;

/**
 *  收录文章元数据数组
 */
@property (nonatomic, strong) NSMutableArray *article;

@end
