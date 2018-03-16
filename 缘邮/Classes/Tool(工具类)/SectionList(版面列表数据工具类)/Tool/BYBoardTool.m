//
//  BYBoardTool.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBoardTool.h"
#import "BYHttpTool.h"
#import "BYBoardResult.h"
#import "BYBoardParam.h"
#import "BYBoard.h"

#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"

@implementation BYBoardTool
+(void)loadBoardListWithBoardParam:(BYBoardParam *)boardParam whenSuccess:(void (^)(BYBoardResult *))success whenfailure:(void (^)(NSError *))failure{
    [BYHttpTool GET:[NSString stringWithFormat:@"%@/section/%@.json", BYBaseURL, boardParam.name] parameters:boardParam.keyValues success:^(id responseObject) {
        
        //解析数据
        BYBoardResult *boardResult = [BYBoardResult objectWithKeyValues:responseObject];
//        BYLog(@"版面返回数据:%@", responseObject);
        
        if (success) {
            success(boardResult);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
