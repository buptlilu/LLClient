//
//  BYCollectionListParam.m
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYCollectionListParam.h"

@implementation BYCollectionListParam

+(instancetype)param{
    BYCollectionListParam *param = [super param];
    param.page = 1;
    param.count = 30;
    return param;
}

@end
