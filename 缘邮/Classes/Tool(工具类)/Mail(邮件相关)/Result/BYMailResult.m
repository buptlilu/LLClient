//
//  BYMailResult.m
//  缘邮
//
//  Created by LiLu on 16/2/18.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMailResult.h"
#import "BYMail.h"

@implementation BYMailResult

+(NSDictionary *)objectClassInArray{
    return @{@"mail" : [BYMail class]};
}

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"BYdescription":@"description"};
}

@end

