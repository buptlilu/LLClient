//
//  BYAccount.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYAccount.h"

#define BYAccessTokenKey  @"access_token"
#define BYExpires_inKey   @"expires_in"
#define BYExpires_dateKey @"expires_date"
#define BYScope           @"scope"
#define BYRefreshToken    @"refresh_token"

@implementation BYAccount
+(instancetype)accountWithDict:(NSDictionary *)dict{
    BYAccount *account = [[self alloc] init];
    
    [account setValuesForKeysWithDictionary:dict];
    
    return account;
}

//归档的时候调用：告诉系统哪个属性需要归档，如何归档
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_access_token forKey:BYAccessTokenKey];
    [aCoder encodeObject:_expires_in forKey:BYExpires_inKey];
    [aCoder encodeObject:_scope forKey:BYScope];
    [aCoder encodeObject:_expires_date forKey:BYExpires_dateKey];
    [aCoder encodeObject:_refresh_token forKey:BYRefreshToken];
}

//解档的时候调用：告诉系统哪个属性需要解档，如何解档
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        //一定要记得赋值
        _access_token = [aDecoder decodeObjectForKey:BYAccessTokenKey];
        _expires_in = [aDecoder decodeObjectForKey:BYExpires_inKey];
        _scope = [aDecoder decodeObjectForKey:BYScope];
        _expires_date = [aDecoder decodeObjectForKey:BYExpires_dateKey];
        _refresh_token = [aDecoder decodeObjectForKey:BYRefreshToken];
    }
    return self;
}

-(void)setExpires_in:(NSString *)expires_in{
    _expires_in = expires_in;
    
    //计算过期的时间 = 当前时间 + 有效期
    _expires_date = [NSDate dateWithTimeIntervalSinceNow:[expires_in longLongValue]];
}

/**
 
 
 [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
 
 }];
 *  KVC底层实现：遍历字典里的所有key（uid）
 一个一个获取key，会去模型里查找setKey（setUid：），有就直接调用这个方法，赋值setUid:obj
 寻找有没有带下划线的_key(_uid)，直接拿到属性赋值
 寻找有没有key的属性，如果有，就直接赋值
 在模型里面找不到对应的Key，就会报错
 */


@end
