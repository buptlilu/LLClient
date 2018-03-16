//
//  BYSearchArticleParam.m
//  缘邮
//
//  Created by LiLu on 16/3/2.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYSearchArticleParam.h"

@implementation BYSearchArticleParam
+(instancetype)param{
    BYSearchArticleParam *param = [super param];
    //下面都是默认值，到时候需要再改
    param.day = 2000;
    param.count = 50;
    param.page = 1;
    return param;
}
@end
