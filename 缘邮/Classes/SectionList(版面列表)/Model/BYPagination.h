//
//  BYPagination.h
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYPagination : NSObject
/**
 *  总页数
 */
@property(nonatomic, assign) int page_all_count;
/**
 *  当前页数
 */
@property(nonatomic, assign) int page_current_count;
/**
 *  每页元素个数
 */
@property(nonatomic, assign) int item_page_count;
/**
 *  所有元素个数
 */
@property(nonatomic, assign) int item_all_count;

@end
