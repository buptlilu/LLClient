//
//  BYMailParam.h
//  缘邮
//
//  Created by LiLu on 16/2/18.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYMailParam : BYBaseParam

/**
 *  只能为inbox|outbox|deleted中的一个，分别是收件箱|发件箱|回收站
 */
@property (nonatomic, copy) NSString *box;

/**
 *  每页信件的数量
 */
@property (nonatomic, assign) int count;

/**
 *  信箱的页数
 */
@property (nonatomic, assign) int page;

@end
