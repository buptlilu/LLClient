//
//  BYHotTopicFrame.m
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYHotTopicFrame.h"
#import "BYArticle.h"

@implementation BYHotTopicFrame

- (void)setArticle:(BYArticle *)article{
    _article = article;
    
    //计算frame
    [self calculateFrame];
    
    //计算cell高度
    _cellHeight = CGRectGetMaxY(_replyCountLabelFrame) + BYBoardArticleMargin;
    _spaceViewFrame = CGRectMake(BYBoardArticleMargin, _cellHeight - 0.5, Main_Screen_Width, 0.5);
    _arrowViewFrame = CGRectMake(Main_Screen_Width - 12 - 16, (_cellHeight - 12 ) * 0.5, 12, 12);
}

-(void)calculateFrame{
    //标题
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName] = BYBoardArticleTitleFont;
    CGFloat titleX = BYBoardArticleMargin;
    CGFloat titleY = BYBoardArticleMargin;
    CGFloat titleW = BYScreenW - 2 * BYBoardArticleMargin - BYHotTopicOffset;
    _article.title = [NSString stringWithFormat:@"%@%@", _article.has_attachment ? @"🔗" : @"", _article.title];
    CGSize titleSize = [_article.title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttr context:nil].size;
    _titleLabelFrame = CGRectMake(titleX, titleY, titleW, titleSize.height);
    
    //版面名称
    CGFloat boardX = BYBoardArticleMargin;
    CGFloat boardY = CGRectGetMaxY(_titleLabelFrame) + BYBoardArticleMargin;
    NSMutableDictionary *boardCountAttr = [NSMutableDictionary dictionary];
    boardCountAttr[NSFontAttributeName] = BYArticleBoardFont;
    CGSize boardSize = [_article.board_name sizeWithAttributes:boardCountAttr];
    _articleBoardFrame = CGRectMake(boardX, boardY, boardSize.width, boardSize.height);
    
    //回复
    NSMutableDictionary *replyCountAttr = [NSMutableDictionary dictionary];
    replyCountAttr[NSFontAttributeName] = BYBoardArticleReplyCountFont;
    CGSize replyCountSize = [@"99999回复" sizeWithAttributes:replyCountAttr];
    CGFloat replyCountX = BYScreenW - BYBoardArticleMargin - BYHotTopicOffset - replyCountSize.width;
    CGFloat replyCountY = CGRectGetMaxY(_titleLabelFrame) + BYBoardArticleMargin;
    _replyCountLabelFrame = CGRectMake(replyCountX, replyCountY, replyCountSize.width, replyCountSize.height);
    
    //时间
    NSMutableDictionary *timeAttr = [NSMutableDictionary dictionary];
    timeAttr[NSFontAttributeName] = BYBoardArticleTimeFont;
    CGSize timeSize = [@"02-23 15:3000" sizeWithAttributes:timeAttr];
    CGFloat timeX = _replyCountLabelFrame.origin.x - timeSize.width;
    CGFloat timeY = CGRectGetMaxY(_titleLabelFrame) + BYBoardArticleMargin;
    _timeLabelFrame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
}


@end
