//
//  BYBoardTool.h
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYBoardResult;
@class BYBoardParam;
@class BYBoard;
@interface BYBoardTool : NSObject

+(void)loadBoardListWithBoardParam:(BYBoardParam *)boardParam whenSuccess:(void(^)(BYBoardResult *boardResult))success whenfailure:(void(^)(NSError *error))failure;


@end
