//
//  BYReplyMailParam.m
//  缘邮
//
//  Created by LiLu on 16/2/20.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYReplyMailParam.h"

@implementation BYReplyMailParam

+(instancetype)param{
    BYReplyMailParam *param = [super param];
    
    //下面都是默认值
    param.signature = 0;
    
    //官方文档给的默认是0,不备份到发件箱,这里我为了测试,改成1
    param.backup = 1;
    
    return param;
}


@end
