//
//  BYArticleResult.m
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYArticleResult.h"

@implementation BYArticleResult

+(NSDictionary *)objectClassInArray{
    return @{@"article" : [BYArticle class], @"like_articles" : [BYArticle class]};
}

@end
