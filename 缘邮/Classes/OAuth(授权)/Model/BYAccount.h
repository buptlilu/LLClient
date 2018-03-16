//
//  BYAccount.h
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYAccount : NSObject

@property(nonatomic, copy) NSString *access_token;
@property(nonatomic, copy) NSString *expires_in;
@property(nonatomic, copy) NSString *refresh_token;
@property(nonatomic, copy) NSString *scope;

//过期时间
@property(nonatomic, strong) NSDate *expires_date;

+(instancetype)accountWithDict:(NSDictionary *)dict;


@end
