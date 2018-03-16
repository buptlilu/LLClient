//
//  BYSetMsgReadParam.h
//  缘邮
//
//  Created by LiLu on 16/2/29.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYSetMsgReadParam : BYBaseParam

/**
 *  只能为at|reply中的一个，分别是@我的文章和回复我的文章
 */
@property (nonatomic, copy) NSString *type;

/**
 *  提醒的索引，为提醒元数据中的index值。如果此参数不存在则设置此类型的所有提醒已读
 */
@property (nonatomic, assign) int index;

@end
