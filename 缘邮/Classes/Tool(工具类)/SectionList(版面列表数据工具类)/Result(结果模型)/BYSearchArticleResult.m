//
//  BYSearchArticleResult.m
//  缘邮
//
//  Created by LiLu on 16/3/2.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYSearchArticleResult.h"
#include "BYArticle.h"

#import "MJExtension.h"

@interface BYSearchArticleResult ()<MJKeyValue>

@end

@implementation BYSearchArticleResult
+(NSDictionary *)objectClassInArray{
    return @{@"threads" : [BYArticle class]};
}
@end
