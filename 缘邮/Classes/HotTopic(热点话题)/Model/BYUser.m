//
//  BYUser.m
//  缘邮
//
//  Created by LiLu on 15/12/1.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYUser.h"

#import "MJExtension.h"

@implementation BYUser
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"BYid" : @"id"};
}

-(NSString *)user_name{
    NSString *userName = [NSString stringWithFormat:@"%@(%@)", _BYid, _user_name];
    return userName;
}
@end
