//
//  BYMailParam.m
//  缘邮
//
//  Created by LiLu on 16/2/18.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMailParam.h"

@implementation BYMailParam

+(instancetype)param{
    BYMailParam *param = [super param];
    
    //下面都是默认值
    param.box = @"inbox";
    param.count = 20;
    param.page = 1;
    return param;
}

@end
