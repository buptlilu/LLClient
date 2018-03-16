//
//  BYAttachment.h
//  缘邮
//
//  Created by LiLu on 15/12/1.
//  Copyright (c) 2015年 lilu. All rights reserved.
//  附件元数据

#import <Foundation/Foundation.h>
#import "BYFile.h"

#import "MJExtension.h"

@interface BYAttachment : NSObject<MJKeyValue>
/**
 *  文件列表
 */
@property(nonatomic, strong) NSArray *file;
/**
 *  剩余空间大小
 */
@property(nonatomic, copy) NSString *remain_space;
/**
 *  剩余附件个数
 */
@property(nonatomic, copy) NSString *remain_count;
@end
