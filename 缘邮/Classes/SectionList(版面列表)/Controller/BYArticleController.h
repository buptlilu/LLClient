//
//  BYArticleController.h
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "DKViewController.h"

@class BYArticleCell, BYArticleParam;
@interface BYArticleController : DKViewController
/**
 *  打开控制器加载文章需要传递的参数
 */
@property(nonatomic, strong) BYArticleParam *articleParam;
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, assign) CGRect imgViewFrame;
@end
