//
//  BYMessageParam.m
//  缘邮
//
//  Created by LiLu on 16/2/22.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMessageParam.h"

@implementation BYMessageParam


+(instancetype)param{
    BYMessageParam *param = [super param];
    
    //下面都是默认值
    param.count = 20;
    param.page = 1;
    return param;
}
@end
