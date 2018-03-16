//
//  BYCollectionFrame.m
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYCollectionFrame.h"
#import "BYCollection.h"

@implementation BYCollectionFrame

- (void)setCollection:(BYCollection *)collection{
    _collection = collection;
    
    //计算frame
    [self calculateFrame];
    
    //计算cell高度
    _cellHeight = CGRectGetMaxY(_collectTimeLabelFrame) + BYBoardArticleMargin;
    
    _spaceViewFrame = CGRectMake(BYBoardArticleMargin, _cellHeight - 0.5, Main_Screen_Width, 0.5);
    
    _arrowViewFrame = CGRectMake(Main_Screen_Width - 12 - 16, (_cellHeight - 12) * 0.5, 12, 12);
}

- (void)calculateFrame{
    //标题
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName] = BYBoardArticleTitleFont;
    CGFloat titleX = BYBoardArticleMargin;
    CGFloat titleY = BYBoardArticleMargin;
    CGFloat titleW = BYScreenW - 2 * BYBoardArticleMargin - BYHotTopicOffset;
    CGSize titleSize = [_collection.title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttr context:nil].size;
    _titleLabelFrame = CGRectMake(titleX, titleY, titleW, titleSize.height);
    
    //版面名称
    CGFloat boardX = BYBoardArticleMargin;
    CGFloat boardY = CGRectGetMaxY(_titleLabelFrame) + BYBoardArticleMargin;
    NSMutableDictionary *boardCountAttr = [NSMutableDictionary dictionary];
    boardCountAttr[NSFontAttributeName] = BYArticleBoardFont;
    CGSize boardSize = [_collection.bname sizeWithAttributes:boardCountAttr];
    _boardLabelFrame = CGRectMake(boardX, boardY, boardSize.width, boardSize.height);
    
    //时间
    NSMutableDictionary *timeAttr = [NSMutableDictionary dictionary];
    timeAttr[NSFontAttributeName] = BYBoardArticleTimeFont;
    CGSize timeSize = [@"于02-23 15:3000收录" sizeWithAttributes:timeAttr];
    CGFloat timeX = BYScreenW - BYBoardArticleMargin - BYHotTopicOffset - timeSize.width;
    CGFloat timeY = boardY;
    _collectTimeLabelFrame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
}

@end
