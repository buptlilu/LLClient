//
//  BYBaseParam.h
//  缘邮
//
//  Created by LiLu on 15/11/30.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYBaseParam : NSObject
@property(nonatomic, copy) NSString *oauth_token;
+(instancetype)param;
@end
