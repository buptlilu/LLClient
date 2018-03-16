//
//  BYBoardArticleFrame.h
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYArticle;


@interface BYBoardArticleFrame : NSObject

@property(nonatomic, strong) BYArticle *article;

@property(nonatomic, assign) CGRect userIconViewFrame;

@property(nonatomic, assign) CGRect userNameLabelFrame;

@property(nonatomic, assign) CGRect timeLabelFrame;

@property(nonatomic, assign) CGRect replyCountLabelFrame;

@property(nonatomic, assign) CGRect titleLabelFrame;

@property(nonatomic, assign) CGRect spaceViewFrame;

@property(nonatomic, assign) CGFloat cellHeight;

@end
