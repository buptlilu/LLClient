//
//  BYDeleteCollectionParam.m
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYDeleteCollectionParam.h"
#import "MJExtension.h"

@interface BYDeleteCollectionParam ()<MJKeyValue>

@end

@implementation BYDeleteCollectionParam

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"BYid": @"id"};
}

@end
