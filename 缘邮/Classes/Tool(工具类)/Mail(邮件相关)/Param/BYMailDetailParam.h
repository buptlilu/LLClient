//
//  BYMailDetailParam.h
//  缘邮
//
//  Created by LiLu on 16/2/19.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYMailDetailParam : BYBaseParam

/**
 *  只能为inbox|outbox|deleted中的一个，分别是收件箱|发件箱|回收站
 */
@property (nonatomic, copy) NSString *box;

/**
 *  信件在信箱的索引,为信箱信息的信件列表中每个信件对象的index值
 */
@property (nonatomic, assign) int num;

@end
