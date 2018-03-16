//
//  BYHotTopicFrame.h
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYArticle;
@interface BYHotTopicFrame : NSObject

@property(nonatomic, strong) BYArticle *article;

@property(nonatomic, assign) CGRect articleBoardFrame;

@property(nonatomic, assign) CGRect timeLabelFrame;

@property(nonatomic, assign) CGRect replyCountLabelFrame;

@property(nonatomic, assign) CGRect titleLabelFrame;

@property(nonatomic, assign) CGRect arrowViewFrame;

@property(nonatomic, assign) CGRect spaceViewFrame;

@property(nonatomic, assign) CGFloat cellHeight;

@end
