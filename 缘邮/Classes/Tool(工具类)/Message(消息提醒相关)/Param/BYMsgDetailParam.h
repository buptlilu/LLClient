//
//  BYMsgDetailParam.h
//  缘邮
//
//  Created by LiLu on 16/2/22.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"
#import "MJExtension.h"

@interface BYMsgDetailParam : BYBaseParam <MJKeyValue>

/**
 *  合法的版面名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文章或主题id
 */
@property (nonatomic, assign) int BYid;

/**
 *  文章所在的版面模式，如果访问文摘，保留，回收站，垃圾箱中的文章需要指定mode，通过文章所在的postion访问
 */
@property (nonatomic, assign) int mode;

@end
