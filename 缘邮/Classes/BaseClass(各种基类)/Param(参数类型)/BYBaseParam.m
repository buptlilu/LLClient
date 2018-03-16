//
//  BYBaseParam.m
//  缘邮
//
//  Created by LiLu on 15/11/30.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBaseParam.h"
#import "BYAccount.h"
#import "BYAccountTool.h"

@implementation BYBaseParam
+(instancetype)param{
    BYBaseParam *param = [[self alloc] init];
    param.oauth_token = [BYAccountTool account].access_token;
    return param;
}
@end
