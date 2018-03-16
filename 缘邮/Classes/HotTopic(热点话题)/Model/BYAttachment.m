//
//  BYAttachment.m
//  缘邮
//
//  Created by LiLu on 15/12/1.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYAttachment.h"

@implementation BYAttachment
+(NSDictionary *)objectClassInArray{
    return @{@"file" : [BYFile class]};
}
@end
