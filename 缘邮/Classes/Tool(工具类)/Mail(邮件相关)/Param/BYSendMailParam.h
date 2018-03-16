//
//  BYSendMailParam.h
//  缘邮
//
//  Created by LiLu on 16/2/20.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"
#import "MJExtension.h"

@interface BYSendMailParam : BYBaseParam <MJKeyValue>

/**
 *  合法的用户id
 */
@property (nonatomic, copy) NSString *BYid;

/**
 *  信件的标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  信件的内容
 */
@property (nonatomic, copy) NSString *content;

/**
 *  信件使用的签名档，0为不使用，从1开始表示使用第几个签名档，默认使用上一次的签名档
 */
@property (nonatomic, assign) int signature;

/**
 *  是否备份到发件箱，0为不备份，1为备份，默认为0
 */
@property (nonatomic, assign) int backup;

@end
