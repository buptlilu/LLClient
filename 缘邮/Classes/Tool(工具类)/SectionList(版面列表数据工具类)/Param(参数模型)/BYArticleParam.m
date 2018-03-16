//
//  BYArticleParam.m
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//  获取文章及评论详情需要的参数

#import "BYArticleParam.h"

@implementation BYArticleParam
+(instancetype)param{
    BYArticleParam *param = [super param];

    //下面都是默认值
    param.count = 10;
    param.page = 1;
    return param;
}
@end
