//
//  BYBoardArticleResult.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBoardArticleResult.h"
#import "BYPagination.h"
#import "BYArticle.h"

@implementation BYBoardArticleResult
+(NSDictionary *)objectClassInArray{
    return @{@"article" : [BYArticle class]};
}
@end
