//
//  BYMailResult.h
//  缘邮
//
//  Created by LiLu on 16/2/18.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class BYPagination;
@interface BYMailResult : NSObject <MJKeyValue>

@property (nonatomic, copy) NSString *BYdescription;

@property (nonatomic, strong) NSMutableArray *mail;

/**
 *  新邮件数
 */
@property (nonatomic, assign) int new_num;

@property (nonatomic, strong) BYPagination *pagination;

@end
