//
//  BYArticleFrame.h
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//  模型

#import <Foundation/Foundation.h>

@class BYArticle, YYTextLayout;
@interface BYArticleFrame : NSObject
//文章
@property(nonatomic, strong) BYArticle *article;
//cell图片
@property(nonatomic, strong) NSMutableArray *imgViews;

/************** 用户信息 *************/
@property(nonatomic, assign) CGRect userViewFrame;
@property(nonatomic, assign) CGRect userIconFrame;
@property(nonatomic, assign) CGRect userNameFrame;
@property(nonatomic, assign) CGRect userTimeFrame;
@property(nonatomic, assign) CGRect userPositionFrame;

/************** 评论信息 *************/
@property(nonatomic, assign) CGRect articleContentFrame;
/**
 *  YYLabel的数据源和布局
 */
@property(nonatomic, strong) YYTextLayout *textLayout;

@property(nonatomic, assign) CGFloat cellHeight;

/************** 工具条 *************/
@property(nonatomic, assign) CGRect toolBarFrame;
@property(nonatomic, assign) CGRect spaceViewFrame;
@end
