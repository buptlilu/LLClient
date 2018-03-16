//
//  BYMessageResult.m
//  缘邮
//
//  Created by LiLu on 16/2/22.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMessageResult.h"
#import "BYMessage.h"

@implementation BYMessageResult

+(NSDictionary *)objectClassInArray{
    return @{@"article" : [BYMessage class]};
}

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"BYdescription":@"description"};
}

@end
