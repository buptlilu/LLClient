//
//  BYBoardCell.h
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBaseCell.h"
@class BYBoard, BYBoardResult, BYBoardCell;

@protocol BYBoardCellDelegate <NSObject>

/**
 *  处理收藏的代理事件
 *
 *  @param cell 自身
 */
- (void)addOrDeleteFavorite:(BYBoardCell *)cell;

@end

@interface BYBoardCell : BYBaseCell
//给个按钮  收藏用的
@property(nonatomic, strong) UIButton *btn;
@property(nonatomic, strong) BYBoardResult *boardResult;
@property(nonatomic, strong) BYBoard *board;

@property(nonatomic, weak) id<BYBoardCellDelegate> delegate;
@end
