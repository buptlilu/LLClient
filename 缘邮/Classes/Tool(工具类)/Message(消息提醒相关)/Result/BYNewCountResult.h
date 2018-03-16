//
//  BYNewCountResult.h
//  缘邮
//
//  Created by LiLu on 16/2/29.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYNewCountResult : NSObject

/**
 *  当前类型的提醒是否启用
 */
@property (nonatomic, assign) BOOL enable;

/**
 *  当前类型的新提醒个数
 */
@property (nonatomic, assign) int new_count;

@end
