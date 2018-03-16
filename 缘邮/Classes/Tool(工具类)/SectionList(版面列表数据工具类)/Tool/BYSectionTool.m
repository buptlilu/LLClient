//
//  BYBoardListTool.m
//  缘邮
//
//  Created by LiLu on 15/11/29.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYSectionTool.h"
#import "BYAccountTool.h"
#import "BYAccount.h"
#import "BYHttpTool.h"
#import "BYSection.h"
#import "BYSectionParam.h"
#import "BYSectionResult.h"
#import "BYSQLCacheTool.h"

#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"

@implementation BYSectionTool

+(void)loadSectionListForRefreshing:(BOOL)flag whenSuccess:(void (^)(NSArray *))success whenfailure:(void (^)(NSError *))failure{
    if (!flag) {
        //先从数据库里取数据
        NSArray *sections = [BYSQLCacheTool sections];
        
        //如果从数据库里取的值有数据,就直接回去
        if (sections.count) {
            if (success) {
                success(sections);
                BYLog(@"没有消耗流量");
            }
            return;
        }
    }
    
    //创建一个参数模型
    BYSectionParam *param = [BYSectionParam param];

    [BYHttpTool GET:[NSString stringWithFormat:@"%@/section.json", BYBaseURL] parameters:param.keyValues success:^(id responseObject) {
          
        //获取到版面列表数据
        BYSectionResult *result = [BYSectionResult objectWithKeyValues:responseObject];
        if (success) {
            success(result.section);
        }
        //从网络获取的,就保存到数据库里
        [BYSQLCacheTool saveWithSections:responseObject[@"section"]];
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
