//
//  BYReplyMsgParam.h
//  缘邮
//
//  Created by LiLu on 16/3/1.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYReplyMsgParam : BYBaseParam
/**
 *  合法的版面名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  新文章的标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  新文章的内容，可以为空
 */
@property (nonatomic, copy) NSString *content;

/**
 *  新文章回复其他文章的id
 */
@property (nonatomic, assign) int reid;

@end
