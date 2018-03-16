//
//  BYUserView.h
//  缘邮
//
//  Created by LiLu on 15/12/6.
//  Copyright (c) 2015年 lilu. All rights reserved.
//  cell里面顶部用户信息

#import <UIKit/UIKit.h>
@class YYLabel, YYTextView;
typedef NS_ENUM(NSInteger, BYArticleCellClickType){
    BYArticleCellClickTypeAtUser = 0,
    BYArticleCellClickTypeHttp = 1
//    BYArticleCellClickType = 2,
//    BYArticleCellClickTypeAt = 3,
//    BYArticleCellClickTypeAt = 4,
//    BYArticleCellClickTypeAt = 5
};
@class BYArticleFrame, BYUserView, BYPlayerToolBar;

@protocol BYUserViewDelegate <NSObject>

/**
 *  回复.写信.at 三个按钮
 *
 *  @param index
 */
- (void)replyItemsDidClick:(NSInteger) index;

/**
 *  点击了链接的时候调用
 *
 *  @param urlStr 链接的url
 */
- (void)contentViewDidClickLink:(NSString *)urlStr;

/**
 *  点击了@某人的时候调用
 *
 *  @param userId 某人的ID
 */
- (void)contentViewDidClickUserId:(NSString *)userId;

/**
 *  点击了图片的时候调用
 *
 *  @param index 图片的index
 */
- (void)contentViewDidClickImage:(NSInteger) index;

/**
 *  点击了音乐播放的时候调用
 *
 *  @param index   <#index description#>
 *  @param toolBar <#toolBar description#>
 */
- (void)contentViewDidClickMusic:(NSInteger) index toolBar:(BYPlayerToolBar *)toolBar;

@end

@interface BYUserView : UIImageView
@property(nonatomic, strong) BYArticleFrame *articleFrame;

@property (nonatomic, weak) id<BYUserViewDelegate> delegate;

/**
 *  正文
 */
@property(nonatomic, weak) YYTextView *articleContentView;

@end
