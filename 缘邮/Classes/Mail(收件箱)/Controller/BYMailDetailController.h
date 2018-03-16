//
//  BYMailDetailController.h
//  缘邮
//
//  Created by LiLu on 16/2/19.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYMailDetailParam;
@interface BYMailDetailController : DKViewController

/**
 *  得到具体是哪封邮件需要的参数
 */
@property (nonatomic, strong) BYMailDetailParam *param;

@end
