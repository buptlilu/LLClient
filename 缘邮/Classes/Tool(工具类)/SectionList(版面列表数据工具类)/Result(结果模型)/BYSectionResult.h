//
//  BYBoardListResult.h
//  缘邮
//
//  Created by LiLu on 15/11/29.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "BYSection.h"

/*
 section_count	int	根分区数量
 section	array	所有根分区元数据所组成的数组
 */
@interface BYSectionResult : NSObject <MJKeyValue>
/**
 *  所有根分区元数据所组成的数组
 */
@property(nonatomic, strong) NSArray *section;

/**
 *  根分区数量
 */
@property(nonatomic, assign) int section_count;

@end
