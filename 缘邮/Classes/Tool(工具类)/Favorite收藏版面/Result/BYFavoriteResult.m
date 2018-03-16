//
//  BYFavoriteResult.m
//  缘邮
//
//  Created by LiLu on 15/12/14.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYFavoriteResult.h"

@implementation BYFavoriteResult
+(NSDictionary *)objectClassInArray{
    return @{@"board" : [BYFavorite class]};
}
@end
