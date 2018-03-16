//
//  BYBoardArticleTool.h
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYSearchArticleParam, BYBoardArticleResult, BYBoardArticleParam, BYSearchArticleResult;
@interface BYBoardArticleTool : NSObject
+(void)loadBoardArticleWithBoardArticleParam:(BYBoardArticleParam *)boardArticleParam whenSuccess:(void(^)(BYBoardArticleResult *boardArticleResult))success whenfailure:(void(^)(NSError *error))failure;

+(void)searchArticleWithArticleParam:(BYSearchArticleParam *)param whenSuccess:(void(^)(BYSearchArticleResult *articleResult))success whenfailure:(void(^)(NSError *error))failure;
@end
