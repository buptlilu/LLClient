//
//  BYBoardArticleParam.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBoardArticleParam.h"

@implementation BYBoardArticleParam
+(instancetype)param{
    BYBoardArticleParam *param = [super param];
    //下面都是默认值，到时候需要再改
    param.mode = 2;
    param.count = 30;
    param.page = 1;
    return param;
}
@end
