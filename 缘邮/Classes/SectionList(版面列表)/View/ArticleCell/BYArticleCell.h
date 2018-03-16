//
//  BYArticleCell.h
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//  帖子cell

#import "BYBaseCell.h"

@class BYArticleFrame, BYReplyToolBarView, LLBottomView, BYArticle, BYAttachment, BYPlayerToolBar, BYArticleCell;
typedef enum {
    BtnTypePlay,//播放
    BtnTypePause,//暂停
    BtnTypePrevious,//上一首
    BtnTypeNext //下一首
}BtnType;
@protocol BYArticleCellDelegate <NSObject>
@optional
- (void)cellItemsDidClick:(NSInteger) index article:(BYArticle *)article;
//点击了链接的时候调用
- (void)cellDidClickUrl:(NSString *)urlStr;

//点击了某人的时候调用
- (void)cellDidclickUser:(NSString *)userId;

//点击了图片的时候调用
- (void)cellDidClickImage:(NSInteger) index attachment:(BYAttachment *)attachment cell:(BYArticleCell *)cell;

//点击了播放器toolBar的时候调用
- (void)cellDidClickToolBar:(BYPlayerToolBar *)toolBar article:(BYArticle *)article type:(BtnType)type;

@end

@interface BYArticleCell : BYBaseCell

//模型
@property(nonatomic, strong) BYArticleFrame *articleFrame;

@property(nonatomic, strong) NSMutableArray *toolBars;

/**
 *  工具条
 */
@property(nonatomic, weak) BYReplyToolBarView *toolBar;

@property (nonatomic, weak) id<BYArticleCellDelegate> delegate;
@end
