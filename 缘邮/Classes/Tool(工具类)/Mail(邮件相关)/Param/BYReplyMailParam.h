//
//  BYReplyMailParam.h
//  缘邮
//
//  Created by LiLu on 16/2/20.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYReplyMailParam : BYBaseParam

/**
 *  回复人的ID
 */
@property (nonatomic, copy) NSString *BYid;

/**
 *  只能为inbox|outbox|deleted中的一个，分别是收件箱|发件箱|回收站
 */
@property (nonatomic, copy) NSString *box;

/**
 *  信件在信箱的索引,为信箱信息的信件列表中每个信件对象的index值
 */
@property (nonatomic, assign) int num;

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
 backup	false	int  0或1	是否备份到发件箱，0为不备份，1为备份，默认为0
 */
@property (nonatomic, assign) int signature;

/**
 *  是否备份到发件箱，0为不备份，1为备份，默认为0
 */
@property (nonatomic, assign) int backup;

@end
